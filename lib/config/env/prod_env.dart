import '../env_config.dart';

void initProdEnvironment() {
  EnvConfig.initialize(
    env: Environment.prod,
    apiBaseUrl: 'https://api.vuna.io/fineract-provider/api/v1',
    tenantId: 'default',
  );
}
