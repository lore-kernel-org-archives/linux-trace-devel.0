Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722BEC43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 14:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B742081C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 14:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEOf2CJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfECOZH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 10:25:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34366 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfECOZH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 10:25:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id e9so8170725wrc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 07:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=abRt0S8GkhmxX2/w0EriIhnTYGMeNKKlNYchu6w+GHA=;
        b=nEOf2CJcOUxd4wAFyFHANMm+++SUgfkPsoC04dNSW3Whfr525pfmwCLfYraJdkCFJ9
         TW1FQFq7rPmvjCofWm+MPbMtc3Pi1m8dsOpGglognxpX3PLQheu2cslb31zmRLHoOg8z
         FO2Ml2uhLai72LU51rIZ89Ub262o0DNwul6weko1xcNZsR+aX8y0A6kcd6p1ZlvtzD13
         U1m2nbfj83E3dAbntGhnFr3U6aq7RLCnyH/MQq+QLT0Q6b9rEn2fNJc0c7meIQOx1egr
         01zkPqc6ysHZt/kczYdT+ze1pT8gVbC1Tod2wjYdRSCt9l6MhHqtAQ06561gkdtC9lJT
         CtqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=abRt0S8GkhmxX2/w0EriIhnTYGMeNKKlNYchu6w+GHA=;
        b=YE64MNegQhVDB+u91wNyy3MPfgNqIzbPXItZSEbEsOO1+KGIfFgeyc32xpwoK+kCHG
         n2+UIAgy7pPl6xmKfK+FsmJNvx9sHtLfxp2pPgFVlMduSj6TFv9pMoQUCZnhsNUTg2+q
         5Q5Q+rt6yAArx0qEuSvoEwakx52W/olx9bepbUUGZu4jPnfmLIHR/Mwovx+auN+T868O
         UL0s2wZN0e+d8Xdbr90/LWCGz60B4+Vq2m+sHvN0QfgV6vA397vc7jBfV8fjr1mQ4h4q
         z+JVEvA/yGULSBu0Ndr3SCxOnjFK/NS9Js/ZkS6hpAcuSDKBHdSdH01aWt2tDy4az+cW
         4Iiw==
X-Gm-Message-State: APjAAAXkGd8ddT1S7++oMhozNE/dfIu3fqdd3zl5QveMVuE57HLTIvuf
        +VGa8Fq0XJeebDgqNk+iD9FyUjtW
X-Google-Smtp-Source: APXvYqxvWnTquJlsfx5gh4DT9JAaFjCPlp+zdNr/HOOHitzxffPKedFPhMrwggzeelc1nNiZH6tLDQ==
X-Received: by 2002:a5d:608f:: with SMTP id w15mr6693070wrt.74.1556893505905;
        Fri, 03 May 2019 07:25:05 -0700 (PDT)
Received: from planxty.redhat.com ([2a02:8108:1700:1960:91dd:e2f9:ed05:ee2b])
        by smtp.gmail.com with ESMTPSA id u2sm4497513wru.36.2019.05.03.07.25.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 03 May 2019 07:25:04 -0700 (PDT)
From:   John Kacur <jkacur@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH] trace-cmd-listen: Fix resource leak of msg_handle
Date:   Fri,  3 May 2019 16:24:49 +0200
Message-Id: <20190503142449.9936-1-jkacur@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix the potential resource leak of msg_handle by calling
tracecmd_msg_handle_close before returning in an error path

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tracecmd/trace-listen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 8bd7badb50e1..3106022eeb39 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -761,6 +761,7 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 		plog("Error with getnameinfo: %s\n",
 		       gai_strerror(s));
 		close(cfd);
+		tracecmd_msg_handle_close(msg_handle);
 		return -1;
 	}
 
-- 
2.20.1

