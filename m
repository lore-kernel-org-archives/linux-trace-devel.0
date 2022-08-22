Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497C0C28D13
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Aug 2022 21:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbiHVVsf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238364AbiHVVsd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 17:48:33 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590CCB1D6
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Aug 2022 14:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661204912; x=1692740912;
  h=message-id:date:mime-version:from:subject:to:cc:
   content-transfer-encoding;
  bh=SHBn6XPZDOGrH4oHT6EZSULM+v73bjP2gI+Iv/T8Anw=;
  b=PImkXoqF8shCRTon6ckeUvE0uNUXC8EeQg5Sr8P00wfCQsQAbQSlTaOG
   hv4IuQE53TwWVIUTljT1X0q+8lthRf/85gTeUgOSkthQs438LbFqxMEfb
   DRKmP8gVJu+4rLKbMLL0jLdm7CRtU9Tji74cyC3E4vnQrj92+MEsIEveB
   zefo2bQMesIJigMXR575CW4+hJKpMrAT2iYSyclwGuaMUobFh+3lCWxSq
   ouRLyCu5OUdHnVj2ESwPq6Xii6Fv32SoXP/HLA/2yMbd3gPEsZk2pcNz3
   DNHElNOFK8cBTWWv738431kZE9tv19WnyGtSkJEY1zFJMFx0/Rmj5x9DE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="276555648"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="276555648"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 14:48:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="698438449"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.127.248]) ([10.212.127.248])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 14:48:31 -0700
Message-ID: <05cf09cd-65e8-be5d-758a-0164a49d7b0e@intel.com>
Date:   Mon, 22 Aug 2022 14:48:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Content-Language: en-US
From:   Dave Jiang <dave.jiang@intel.com>
Subject: retrieving non-numeral fields from an event record
To:     linux-trace-devel@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Attempting to use libtraceevent to retrieve fields from events. For example here's the event I'm trying to parse:

  check-events.sh-5983    [002] ..... 261848.250238: cxl_dram_event: cxl_mem.7: Fatal time=0 id=b3cb1
d60-069c-ab4e-b8af-4e9bfb5c9624 handle=1 related_handle=0 hdr_flags='Performance Degraded': phys_add
r=8000 volatile=FALSE desc='Threshold event' type='Invalid Address' trans_type='Internal Media Scrub
' channel=1 rank=0 nibble_mask=0 bank_group=5 bank=2 row=0 column=1024 cor_mask=00 00 00 00 00 00 00
  00 00 00 00 00 00 00 00 0000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 valid_flags='CHANNEL|BANK
  GROUP|BANK|COLUMN'

Here's me iterating through all the fields and using tep_get_field_raw() trying to retrieve the fields. It appears that
if the field is a string type I'm not able to retrieve the field and the error written back in the seq file is
"CANT FIND FIELD". Am I doing something wrong or using the wrong API to retrieve those type of fields?

failed to get field: time
<CANT FIND FIELD time>
got field: id, len: 16
got field: handle, len: 2
got field: related_handle, len: 2
failed to get field: hdr_flags
<CANT FIND FIELD hdr_flags>
got field: phys_addr, len: 8
failed to get field: volatile
<CANT FIND FIELD volatile>
failed to get field: desc
<CANT FIND FIELD desc>
got field: type, len: 1
failed to get field: trans_type
<CANT FIND FIELD trans_type>
got field: channel, len: 1
got field: rank, len: 1
got field: nibble_mask, len: 4
got field: bank_group, len: 1
got field: bank, len: 1
got field: row, len: 4
got field: column, len: 2
got field: cor_mask, len: 32
failed to get field: valid_flags
<CANT FIND FIELD valid_flags>

