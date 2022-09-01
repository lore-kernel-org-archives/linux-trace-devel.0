Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434CAECAAD2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Sep 2022 21:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbiIAVNI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiIAVNG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 17:13:06 -0400
X-Greylist: delayed 974 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Sep 2022 14:13:05 PDT
Received: from mail.codeweavers.com (mail.codeweavers.com [65.103.31.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5F78FD46
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Sep 2022 14:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=codeweavers.com; s=6377696661; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2E04r1fXk2bcGNXf8leeSDvedEuSL/vsEPSgNjmZZZU=; b=vOPxZb1vPxZm2bge307yFFAEyj
        K0jqOVAYkiFYfQsb/D/slo9oiHwEPXD2paYmlgz14Z/xh30H4MCRpT5h5rYSkJBP+jD1wIMxID7cq
        ZMYmkquE5dbojVLHIHGOav03Hzz10LkQaSrySNoBLGQNCzbx/Suvubwo7cQNejKz9fuk=;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
        by mail.codeweavers.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <zfigura@codeweavers.com>)
        id 1oTrF4-0007cb-IW; Thu, 01 Sep 2022 15:56:50 -0500
From:   Zebediah Figura <zfigura@codeweavers.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Zeb Figura <zfigura@codeweavers.com>
Subject: [PATCH] tracecmd extract: Allow using --compression.
Date:   Thu,  1 Sep 2022 15:56:38 -0500
Message-Id: <20220901205638.3247090-1-zfigura@codeweavers.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Zeb Figura <zfigura@codeweavers.com>

This is already supported and works as expected; allow the option to be
specified.
---
 tracecmd/trace-record.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3442e9b..70fb187 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6648,7 +6648,6 @@ static void parse_record_options(int argc,
 		case OPT_compression:
 			cmd_check_die(ctx, CMD_start, *(argv+1), "--compression");
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--compression");
-			cmd_check_die(ctx, CMD_extract, *(argv+1), "--compression");
 			cmd_check_die(ctx, CMD_stream, *(argv+1), "--compression");
 			cmd_check_die(ctx, CMD_profile, *(argv+1), "--compression");
 			if (strcmp(optarg, "any") && strcmp(optarg, "none") &&
-- 
2.37.2

