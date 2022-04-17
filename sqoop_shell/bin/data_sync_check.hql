select 'ods_agent_agent_change_log_da' as tbname, count(1) as cnt from ods.ods_agent_agent_change_log_da where pt=${hiveconf:pt}
union all
select 'ods_agent_agent_da' as tbname, count(1) as cnt from ods.ods_agent_agent_da where pt=${hiveconf:pt}
union all
select 'ods_agent_agent_entry_da' as tbname, count(1) as cnt from ods.ods_agent_agent_entry_da where pt=${hiveconf:pt}
union all
select 'ods_agent_agent_leave_da' as tbname, count(1) as cnt from ods.ods_agent_agent_leave_da where pt=${hiveconf:pt}
union all
select 'ods_agent_agent_mobile_da' as tbname, count(1) as cnt from ods.ods_agent_agent_mobile_da where pt=${hiveconf:pt}
union all
select 'ods_crm_cdel_hold_da' as tbname, count(1) as cnt from ods.ods_crm_cdel_hold_da where pt=${hiveconf:pt}
union all
select 'ods_crm_cdel_manage_da' as tbname, count(1) as cnt from ods.ods_crm_cdel_manage_da where pt=${hiveconf:pt}
union all
select 'ods_crm_cdel_typing_da' as tbname, count(1) as cnt from ods.ods_crm_cdel_typing_da where pt=${hiveconf:pt}
union all
select 'ods_crm_cust_manage_da' as tbname, count(1) as cnt from ods.ods_crm_cust_manage_da where pt=${hiveconf:pt}
union all
select 'ods_hdel_city_da' as tbname, count(1) as cnt from ods.ods_hdel_city_da where pt=${hiveconf:pt}
union all
select 'ods_hdel_hdel_da' as tbname, count(1) as cnt from ods.ods_hdel_hdel_da where pt=${hiveconf:pt}
union all
select 'ods_hdel_hdel_prospect_da' as tbname, count(1) as cnt from ods.ods_hdel_hdel_prospect_da where pt=${hiveconf:pt}
union all
select 'ods_hdel_house_da' as tbname, count(1) as cnt from ods.ods_hdel_house_da where pt=${hiveconf:pt}
union all
select 'ods_hdel_resblock_da' as tbname, count(1) as cnt from ods.ods_hdel_resblock_da where pt=${hiveconf:pt}
union all
select 'ods_shop_brand_da' as tbname, count(1) as cnt from ods.ods_shop_brand_da where pt=${hiveconf:pt}
union all
select 'ods_shop_corp_da' as tbname, count(1) as cnt from ods.ods_shop_corp_da where pt=${hiveconf:pt}
union all
select 'ods_shop_shop_da' as tbname, count(1) as cnt from ods.ods_shop_shop_da where pt=${hiveconf:pt}
union all
select 'ods_tlook_tlook_da' as tbname, count(1) as cnt from ods.ods_tlook_tlook_da where pt=${hiveconf:pt}
union all
select 'ods_tlook_tlook_feedback_da' as tbname, count(1) as cnt from ods.ods_tlook_tlook_feedback_da where pt=${hiveconf:pt}
union all
select 'ods_trade_draft_order_da' as tbname, count(1) as cnt from ods.ods_trade_draft_order_da where pt=${hiveconf:pt}
union all
select 'ods_trade_sign_order_da' as tbname, count(1) as cnt from ods.ods_trade_sign_order_da where pt=${hiveconf:pt}
union all
select 'ods_trade_trade_order_da' as tbname, count(1) as cnt from ods.ods_trade_trade_order_da where pt=${hiveconf:pt}
;
