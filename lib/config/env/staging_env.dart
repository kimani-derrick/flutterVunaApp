import '../env_config.dart';

void initStagingEnvironment() {
  EnvConfig.initialize(
    env: Environment.staging,
    apiBaseUrl: 'https://api.staging.vuna.io/fineract-provider/api/v1',
    tenantId: 'default',
  );
}
