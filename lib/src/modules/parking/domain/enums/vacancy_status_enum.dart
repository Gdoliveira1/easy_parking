enum VacancyStatusEnum {
  released(0, "Liberado"),
  busy(1, "Ocupado");

  final int code;
  final String title;

  const VacancyStatusEnum(this.code, this.title);

  factory VacancyStatusEnum.fromCode(int byte) {
    return VacancyStatusEnum.values.firstWhere(
      (item) => item.code == byte,
    );
  }
}
