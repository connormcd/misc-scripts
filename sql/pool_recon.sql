-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine pool_seq

set verify off
set echo on
  SELECT
        porg.pooling_org_seq,
        nvl(posum.collate_gross_investment,0),
        nvl(posum.refunds,0),
        nvl(posum.subsidies,0),
        nvl(posum.fractions,0),
        nvl(posum.commission,0)
    FROM
        tote.pooling_org_summary posum,
        tote.pooling_org porg
    WHERE
         posum.pool_seq = &&pool_seq
    AND  porg.pooling_org_seq = posum.pooling_org_seq
    AND  porg.external_ind = 'N';

    SELECT
        nvl(sum(povsum.collate_gross_investment),0),
        nvl(sum(povsum.refunds),0),
        nvl(sum(povsum.subsidies),0),
        nvl(sum(povsum.fractions),0),
        nvl(sum(povsum.commission),0)
    FROM
        tote.pooling_org_venue_summary povsum,
        tote.pooling_org porg
    WHERE
         povsum.pool_seq = &&pool_seq
    AND  porg.pooling_org_seq = povsum.pooling_org_seq
    AND  porg.external_ind = 'N';

    SELECT
         porg.pooling_org_seq
        ,nvl(posum.dividend_trim,0)
        ,nvl(posum.refund_trim,0)
        ,nvl(posum.priced_dividend_trim,0)
        ,nvl(posum.priced_refund_trim,0)
    FROM
        tote.pooling_org_summary posum,
        tote.pooling_org porg
    WHERE
         posum.pool_seq = &&pool_seq
    AND  porg.pooling_org_seq = posum.pooling_org_seq
    AND  porg.external_ind = 'N';

    SELECT
      pricing_integrity_tolerance
    FROM
      tote.system_config;



    SELECT
        porg.pooling_org_seq,
        posum.collate_gross_investment,
        posum.refunds,
        posum.subsidies,
        posum.fractions,
        posum.commission,
        posum.payout_pool
    FROM
        tote.pooling_org_summary posum,
        tote.pooling_org porg
    WHERE
         posum.pool_seq = &&pool_seq
    AND  porg.pooling_org_seq = posum.pooling_org_seq
    AND  porg.external_ind = 'N';

    SELECT
        porg.pooling_org_seq,
        posum.collate_gross_investment,
        posum.refunds
    FROM
        tote.pooling_org_summary posum,
        tote.pooling_org porg
    WHERE
         posum.pool_seq = &&pool_seq
    AND  porg.pooling_org_seq = posum.pooling_org_seq
    AND  porg.external_ind = 'Y';

        SELECT
            posetl.total_pool_gross_investment,
            posetl.misc_refunds,
            posetl.misc_subsidies,
            posetl.misc_fractions,
            posetl.misc_commission,
            posetl.misc_payout,
            posetl.settlement_to_external_vendor
        FROM
            tote.pooling_org_settlement posetl,
            tote.pooling_org porg
        WHERE
             posetl.pool_seq = &&pool_seq
        AND  porg.pooling_org_seq = posetl.pooling_org_seq
        AND  porg.external_ind = 'Y';

        SELECT
           posetl.settlement_to_external_vendor
        FROM
           tote.pooling_org_settlement posetl,
           tote.pooling_org porg
        WHERE
            posetl.pool_seq = &&pool_seq
        AND  porg.pooling_org_seq = posetl.pooling_org_seq
        AND  porg.external_ind = 'N';

    SELECT
      pool_settlement_tolerance, commission_tolerance, payout_tolerance
    FROM
      tote.system_config;

set verify on
set echo off
