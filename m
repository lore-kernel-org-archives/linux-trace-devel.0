Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC1FC433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7752076E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JD8OR3x5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390020AbgFYKFX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390891AbgFYKFW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:05:22 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF453C061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:21 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g75so4942785wme.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/CpQ4TKXB4oSJlA07MFdqGq0VyfGfA3Bz33BRX1HVIY=;
        b=JD8OR3x5vhZ2YTVa+j4MKg8lZjsHdnv1sIBr/odJ/ibj5XhIPiQo3j4Rep9Laerqqd
         cfEJ9SJIGxDxN7xNeF8lwFF7+J1s7WyDtIcJx+jsQTztw0MC6+ugIZUzwdN85sSaIerq
         1Oq6/0FAz90FTrxgcdmKqjzmoRl5Bcp8bXYjHWjiYcwUkyKpTu6KD7KGNgETYu2a0RIe
         YKiRcYbOuKlQRcxHbkTPEn2w24ipNaFUUKwmw4LaKX/XUocshEORbwZFZUp3oJIvFrhs
         R2ITMtqB25hHj3YoDEkvCRwPXa3dJFENoRr0DfqHSgZaU8map7C9mbKQg4+H0WmU9AgY
         wJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/CpQ4TKXB4oSJlA07MFdqGq0VyfGfA3Bz33BRX1HVIY=;
        b=LgVN2WlTVzWJTHNMc2fkO42bfJfbr82r020pGKuz2fGMyy7C9xYiBZ4juU2IzghB53
         nNSJ/Ia0nlrwLA93TOQcY8qy2sdRPvKmDfmxA81s56LSseaiYdk83/F+INDJU12KJo+F
         fbRUjBzpQAEI6G28gjc1ZZQJs8YH+zkvk+a3WxTsKAV6y2rtWPS2AOFe92Uaa03oRuzL
         EUZbIlxPtdjFJst0e5er3rnFslmeaPq/dPc1EN4xxEOOhbTBaN03fuWohjbDRsR6aidG
         DyPF2yD55jYOExHGywGdAsA7WomIis05IOgGtbLQ5p+jokzHzcEbYXD7VHdQ0pkvvBRA
         3cvg==
X-Gm-Message-State: AOAM533svtX2cSGnYFrkrnq+2s1NbmNnrgY62o/feCuWcaLHJLf5iokE
        HLhu0GT3Ra9iZQtwzuF4U1IiKYpR3s0=
X-Google-Smtp-Source: ABdhPJzEbL8sEYCEnseEJrwW/EGGJDluaOq7nUW75ToWqWc6o2TLurbH7nMeddwJqlLHGtfn9dHmVw==
X-Received: by 2002:a1c:f707:: with SMTP id v7mr2455302wmh.2.1593079520457;
        Thu, 25 Jun 2020 03:05:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v7sm31268204wrp.45.2020.06.25.03.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:05:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/15] tools lib traceevent: Add proper KBUFFER_TYPE_TIME_STAMP handling
Date:   Thu, 25 Jun 2020 13:05:09 +0300
Message-Id: <20200625100516.365338-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625100516.365338-1-tz.stoyanov@gmail.com>
References: <20200625100516.365338-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

Kernel commit dc4e2801d400 (ring-buffer: Redefine the unimplemented
RINGBUF_TYPE_TIME_STAMP) changed the way the ring buffer timestamps
work - after that commit the previously unimplemented
RINGBUF_TYPE_TIME_STAMP type causes the time delta to be used as a
timestamp rather than a delta to be added to the timestamp.

The trace-cmd code didn't get updated to handle this, so misinterprets
the event data for this case, which causes a cascade of errors,
including trace-report not being able to identify synthetic (or any
other) events generated by the histogram code (which uses TIME_STAMP
mode).  For example, the following triggers along with the trace-cmd
shown cause an UNKNOWN_EVENT error and trace-cmd report crash:

  # echo 'wakeup_latency  u64 lat pid_t pid char comm[16]' > /sys/kernel/debug/tracing/synthetic_events

  # echo 'hist:keys=pid:ts0=common_timestamp.usecs if comm=="ping"' > /sys/kernel/debug/tracing/events/sched/sched_wakeup/trigger
  # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0:onmatch(sched.sched_wakeup).trace(wakeup_latency,$wakeup_lat,next_pid,next_comm) if next_comm=="ping"' > /sys/kernel/debug/tracing/events/sched/sched_switch/trigger
  # echo 'hist:keys=comm,pid,lat:wakeup_lat=lat:sort=lat' > /sys/kernel/debug/tracing/events/synthetic/wakeup_latency/trigger

  # trace-cmd record -e wakeup_latency -e sched_wakeup -f comm==\"ping\" ping localhost -c 5

  # trace-cmd report
  CPU 0 is empty
  CPU 1 is empty
  CPU 2 is empty
  CPU 3 is empty
  CPU 5 is empty
  CPU 6 is empty
  CPU 7 is empty
  cpus=8
    ug! no event found for type 0
  [UNKNOWN TYPE 0]
    ug! no event found for type 11520
  Segmentation fault (core dumped)

After this patch we get the correct interpretation and the events are
shown properly:

  # trace-cmd report
  CPU 0 is empty
  CPU 1 is empty
  CPU 2 is empty
  CPU 3 is empty
  CPU 5 is empty
  CPU 6 is empty
  CPU 7 is empty
  cpus=8
          <idle>-0     [004] 23284.341392: sched_wakeup:         ping:12031 [120] success=1 CPU:004
          <idle>-0     [004] 23284.341464: wakeup_latency:       lat=58, pid=12031, comm=ping
          <idle>-0     [004] 23285.365303: sched_wakeup:         ping:12031 [120] success=1 CPU:004
          <idle>-0     [004] 23285.365382: wakeup_latency:       lat=64, pid=12031, comm=ping
          <idle>-0     [004] 23286.389290: sched_wakeup:         ping:12031 [120] success=1 CPU:004
          <idle>-0     [004] 23286.389378: wakeup_latency:       lat=72, pid=12031, comm=ping
          <idle>-0     [004] 23287.413213: sched_wakeup:         ping:12031 [120] success=1 CPU:004
          <idle>-0     [004] 23287.413291: wakeup_latency:       lat=64, pid=12031, comm=ping

Link: http://lkml.kernel.org/r/1567628224.13841.4.camel@kernel.org

Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/kbuffer-parse.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/kbuffer-parse.c b/tools/lib/traceevent/kbuffer-parse.c
index 583db99aee94..f1640d651c8a 100644
--- a/tools/lib/traceevent/kbuffer-parse.c
+++ b/tools/lib/traceevent/kbuffer-parse.c
@@ -361,6 +361,7 @@ translate_data(struct kbuffer *kbuf, void *data, void **rptr,
 		break;
 
 	case KBUFFER_TYPE_TIME_EXTEND:
+	case KBUFFER_TYPE_TIME_STAMP:
 		extend = read_4(kbuf, data);
 		data += 4;
 		extend <<= TS_SHIFT;
@@ -369,10 +370,6 @@ translate_data(struct kbuffer *kbuf, void *data, void **rptr,
 		*length = 0;
 		break;
 
-	case KBUFFER_TYPE_TIME_STAMP:
-		data += 12;
-		*length = 0;
-		break;
 	case 0:
 		*length = read_4(kbuf, data) - 4;
 		*length = (*length + 3) & ~3;
@@ -397,7 +394,11 @@ static unsigned int update_pointers(struct kbuffer *kbuf)
 
 	type_len = translate_data(kbuf, ptr, &ptr, &delta, &length);
 
-	kbuf->timestamp += delta;
+	if (type_len == KBUFFER_TYPE_TIME_STAMP)
+		kbuf->timestamp = delta;
+	else
+		kbuf->timestamp += delta;
+
 	kbuf->index = calc_index(kbuf, ptr);
 	kbuf->next = kbuf->index + length;
 
@@ -454,7 +455,9 @@ static int __next_event(struct kbuffer *kbuf)
 		if (kbuf->next >= kbuf->size)
 			return -1;
 		type = update_pointers(kbuf);
-	} while (type == KBUFFER_TYPE_TIME_EXTEND || type == KBUFFER_TYPE_PADDING);
+	} while (type == KBUFFER_TYPE_TIME_EXTEND ||
+		 type == KBUFFER_TYPE_TIME_STAMP ||
+		 type == KBUFFER_TYPE_PADDING);
 
 	return 0;
 }
-- 
2.26.2

