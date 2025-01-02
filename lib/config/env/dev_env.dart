import '../env_config.dart';

void initDevEnvironment() {
  EnvConfig.initialize(
    env: Environment.dev,
    apiBaseUrl: 'https://api.vuna.io/fineract-provider/api/v1',
    tenantId: 'default',
  );
}
