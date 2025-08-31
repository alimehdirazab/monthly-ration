part of 'view.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  _AddressView();
  }
}

class _AddressView extends StatefulWidget {
  const _AddressView();

  @override
  State<_AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<_AddressView> {
  @override
  void initState() {
    super.initState();
    // Load addresses when screen opens
    context.read<AuthCubit>().getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GroceryColorTheme().primary,
        elevation: 0,
        title: Text(
          'My Addresses',
          style: GroceryTextTheme().headingText.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle success/error states
          if (state.createAddressApiState.apiCallState == APICallState.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Address created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Reload addresses
            context.read<AuthCubit>().getAddress();
          } else if (state.createAddressApiState.apiCallState == APICallState.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.createAddressApiState.errorMessage ?? 'Failed to create address'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state.updateAddressApiState.apiCallState == APICallState.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Address updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<AuthCubit>().getAddress();
          }

          if (state.deleteAddressApiState.apiCallState == APICallState.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Address deleted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<AuthCubit>().getAddress();
          }

          if (state.setAddressApiState.apiCallState == APICallState.loaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Default address updated!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<AuthCubit>().getAddress();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Add Address Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddEditAddressDialog(context, null),
                  icon: const Icon(Icons.add, color: Colors.black),
                  label: Text(
                    'Add New Address',
                    style: GroceryTextTheme().bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GroceryColorTheme().primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Address List
              Expanded(
                child: _buildAddressList(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressList(AuthState state) {
    if (state.getAddressApiState.apiCallState == APICallState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.getAddressApiState.apiCallState == APICallState.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load addresses',
              style: GroceryTextTheme().bodyText.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<AuthCubit>().getAddress(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final addresses = state.getAddressApiState.model?.data ?? [];

    if (addresses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No addresses found',
              style: GroceryTextTheme().bodyText.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first address to get started',
              style: GroceryTextTheme().lightText.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return _buildAddressCard(address, state);
      },
    );
  }

  Widget _buildAddressCard(Address address, AuthState state) {
    final isDefault = address.isDefaultAddress;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault ? GroceryColorTheme().primary : Colors.grey[300]!,
          width: isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and default badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    address.name ?? 'No Name',
                    style: GroceryTextTheme().bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: GroceryColorTheme().primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Default',
                      style: GroceryTextTheme().lightText.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Phone
            if (address.phone != null)
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    address.phone!,
                    style: GroceryTextTheme().lightText.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 8),
            
            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _formatAddress(address),
                    style: GroceryTextTheme().lightText.copyWith(
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                if (!isDefault)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.setAddressApiState.apiCallState == APICallState.loading
                          ? null
                          : () => context.read<AuthCubit>().setAddress(id: address.id!),
                      icon: state.setAddressApiState.apiCallState == APICallState.loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.star_border, size: 18),
                      label: const Text('Set Default'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: GroceryColorTheme().primary),
                        foregroundColor: GroceryColorTheme().primary,
                      ),
                    ),
                  ),
                
                if (!isDefault) const SizedBox(width: 8),
                
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddEditAddressDialog(context, address),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: const BorderSide(color: Colors.grey),
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: state.deleteAddressApiState.apiCallState == APICallState.loading
                        ? null
                        : () => _showDeleteConfirmation(context, address),
                    icon: state.deleteAddressApiState.apiCallState == APICallState.loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.delete, size: 18),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAddress(Address address) {
    List<String> parts = [];
    
    if (address.addressLine1?.isNotEmpty == true) {
      parts.add(address.addressLine1!);
    }
    if (address.addressLine2?.isNotEmpty == true) {
      parts.add(address.addressLine2!);
    }
    if (address.city?.isNotEmpty == true) {
      parts.add(address.city!);
    }
    if (address.state?.isNotEmpty == true) {
      parts.add(address.state!);
    }
    if (address.country?.isNotEmpty == true) {
      parts.add(address.country!);
    }
    if (address.pincode?.isNotEmpty == true) {
      parts.add(address.pincode!);
    }
    
    return parts.join(', ');
  }

  void _showAddEditAddressDialog(BuildContext context, Address? address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditAddressDialog(
        address: address,
        onSave: (addressData) {
          if (address == null) {
            // Create new address
            context.read<AuthCubit>().createAddress(
              name: addressData['name']!,
              phone: addressData['phone']!,
              addressLine1: addressData['addressLine1']!,
              addressLine2: addressData['addressLine2']!,
              city: addressData['city']!,
              statee: addressData['state']!,
              country: addressData['country']!,
              pincode: addressData['pincode']!,
              isDefault: addressData['isDefault'] == 'true',
            );
          } else {
            // Update existing address
            context.read<AuthCubit>().updateAddress(
              id: address.id!,
              name: addressData['name']!,
              phone: addressData['phone']!,
              addressLine1: addressData['addressLine1']!,
              addressLine2: addressData['addressLine2']!,
              city: addressData['city']!,
              statee: addressData['state']!,
              country: addressData['country']!,
              pincode: addressData['pincode']!,
              isDefault: addressData['isDefault'] == 'true',
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthCubit>().deleteAddress(id: address.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class AddEditAddressDialog extends StatefulWidget {
  final Address? address;
  final Function(Map<String, String>) onSave;

  const AddEditAddressDialog({
    super.key,
    this.address,
    required this.onSave,
  });

  @override
  State<AddEditAddressDialog> createState() => _AddEditAddressDialogState();
}

class _AddEditAddressDialogState extends State<AddEditAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _pincodeController = TextEditingController();
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _nameController.text = widget.address!.name ?? '';
      _phoneController.text = widget.address!.phone ?? '';
      _addressLine1Controller.text = widget.address!.addressLine1 ?? '';
      _addressLine2Controller.text = widget.address!.addressLine2 ?? '';
      _cityController.text = widget.address!.city ?? '';
      _stateController.text = widget.address!.state ?? '';
      _countryController.text = widget.address!.country ?? '';
      _pincodeController.text = widget.address!.pincode ?? '';
      _isDefault = widget.address!.isDefaultAddress;
    } else {
      _countryController.text = 'India'; // Default country
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Title
                Text(
                  widget.address == null ? 'Add New Address' : 'Edit Address',
                  style: GroceryTextTheme().headingText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildTextField('Full Name', _nameController, required: true),
                        _buildTextField('Phone Number', _phoneController, required: true, keyboardType: TextInputType.phone),
                        _buildTextField('Address Line 1', _addressLine1Controller, required: true),
                        _buildTextField('Address Line 2', _addressLine2Controller),
                        _buildTextField('City', _cityController, required: true),
                        _buildTextField('State', _stateController, required: true),
                        _buildTextField('Country', _countryController, required: true),
                        _buildTextField('Pincode', _pincodeController, required: true, keyboardType: TextInputType.number),
                        
                        const SizedBox(height: 16),
                        
                        // Default address switch
                        Row(
                          children: [
                            Switch(
                              value: _isDefault,
                              onChanged: (value) {
                                setState(() {
                                  _isDefault = value;
                                });
                              },
                              activeColor: GroceryColorTheme().primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Set as default address',
                              style: GroceryTextTheme().bodyText,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Save button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveAddress,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GroceryColorTheme().primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              widget.address == null ? 'Add Address' : 'Update Address',
                              style: GroceryTextTheme().bodyText.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: GroceryColorTheme().primary),
          ),
        ),
        validator: required
            ? (value) {
                if (value?.isEmpty ?? true) {
                  return '$label is required';
                }
                return null;
              }
            : null,
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final addressData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'addressLine1': _addressLine1Controller.text,
        'addressLine2': _addressLine2Controller.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'country': _countryController.text,
        'pincode': _pincodeController.text,
        'isDefault': _isDefault.toString(),
      };
      
      widget.onSave(addressData);
      Navigator.of(context).pop();
    }
  }
}
