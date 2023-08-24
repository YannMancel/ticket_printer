import 'package:ticket_printer/src/_src.dart';

/// The dimensions are in mm.
class TicketConfigurationModel extends TicketConfigurationEntity {
  const TicketConfigurationModel({
    super.width = 55,
    super.height = 29,
    super.gap = 3,
  });

  factory TicketConfigurationModel.fromEntity(
    TicketConfigurationEntity entity,
  ) {
    return TicketConfigurationModel(
      width: entity.width,
      height: entity.height,
      gap: entity.gap,
    );
  }
}
