Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1243BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Apr 2022 04:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiDKEMj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 00:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiDKEMi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 00:12:38 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151231179
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Apr 2022 21:10:26 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r7so9100769wmq.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Apr 2022 21:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nGaOAQwOzKUWV9vgNt7xsP/aGypJoTQgjgOZLdcWTGo=;
        b=nlVMMOAjY2AkLbMdw41v5BDQdCC7mxbT/cYi9QVMuOYSYu6//mmWln0fnRfAtAKdRq
         RPSiuYaTTp3nvf3aBfEPDjLnNqjhdX5fkQQPgVT84MXkvUDvGth4f77ovDCgfzDE07tB
         ImPku1V08p/WRpBCBxWD/+56PZKdSjfFj/4PvrtQARxb8FGNx7XAX2u0BxOiad9ijejW
         7d1Dpc+F1FHoB+oQmPwtF7YMIxhOEFGOc4BHh5LoN02cjdidQLP/dZCrpni63pWmfiSF
         HRevgsZIRTCdUtThI4a7unHQI4oqHibDaToMuRESqeeqET7GIFxJkCjG/9N5sjwVAV5y
         grbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nGaOAQwOzKUWV9vgNt7xsP/aGypJoTQgjgOZLdcWTGo=;
        b=GNfOojnbeecG/enU89/UYTZcIHXDRE1eo9CDzNRGttDuP4CaZZ8ar99EFJsITA/dAF
         NjSN5sagX0r3g6H3lD+xvC4EAjVHjd2M1PjovalmWeophVyxtx+Et56wRAZX3cN9PUKO
         8Ep0UDh4OWEF9ZKi1lcAMj9eI97ejngdZkrYDmIL3dvlqd1YOMy4i4qXrg0qgcJlfC2K
         hOBjYUG0qnjF9w6dgIpRmlW1UsxEz0UpIJn0Sl577oPt2sYX8kAvyYrGw+rLhaN+Z37T
         P9kXiMTGFkzrIQpNlI9kQDPZTjECmVmO25eTcO6eAy2DSQRaxhKyCAn3v5fUxT4p4LpE
         DSxw==
X-Gm-Message-State: AOAM531vVgblib8AhQJugTH/dod+VulyGlmw1X04e36X+V1BGqoamA9L
        G+lF1hWo7EG3fdOM57h/zuXD2IDu8cQ=
X-Google-Smtp-Source: ABdhPJxLmfQmR0Y/zPMzcPT7+GjBGFjuakbm9fI5mB0O4+nVXuDwbn1VTgZ6msB2qBwa1Ye5a34bzQ==
X-Received: by 2002:a05:600c:a03:b0:37b:daff:6146 with SMTP id z3-20020a05600c0a0300b0037bdaff6146mr27041391wmp.85.1649650224321;
        Sun, 10 Apr 2022 21:10:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q17-20020adff951000000b00205c1b97ac4sm24901073wrr.20.2022.04.10.21.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 21:10:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Disable PTP timesync internal debug
Date:   Mon, 11 Apr 2022 07:10:22 +0300
Message-Id: <20220411041022.132420-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

PTP internal debug prints various information about the work of the
host-guest timestamp synchronization with PTP algorithm. It also dumps
a few text files on the guest with the results of each PTP iteration,
used for debug purposes. The internal define, which turns on this logic
is forgotten.

Fixes: fd86ac9e ("trace-cmd: PTP-like algorithm for host - guest timestamp synchronization")
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync-ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
index 70242ee3..4f780562 100644
--- a/lib/trace-cmd/trace-timesync-ptp.c
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -35,7 +35,7 @@ typedef __s64 s64;
 #define PTP_SYNC_PKT_END	5
 
 /* print time sync debug messages */
-#define TSYNC_DEBUG
+/* #define TSYNC_DEBUG */
 
 struct ptp_clock_sync {
 	struct tep_handle	*tep;
-- 
2.35.1

