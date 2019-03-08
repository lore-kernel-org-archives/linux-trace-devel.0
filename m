Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6782BC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434032087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfCHNhh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40396 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfCHNhg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id t6so2189460wrw.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkTfb07DSfHUuZgYyltvJ7+hZOkAvHIhF2h+y9ewlP4=;
        b=hBRepYwCBu7A+6Kd3ti0g74Axp2HkiHINnIrfUOHPsw/ePECiNQC+yX23w6D5gp288
         gJe4z+/Zka8/mgsE6CPDttwavaf67++VfgdxCSAf0DEfOLSCfnGpk8Pf7BcOS3I5Bw6K
         uG0GW80iepzHcPC9mlVqIoIOSZEmOhqBfWOTZ7/2c84Mt+/E+ql3PeL13F+o3aH58AP0
         rrBLkqh9y9vDaVAkdtt2KRSWP7vebMLBFworScQnEBHXkIfgdz0CcNVHnLHi1O/1JSXJ
         WRHal7Vn8S/MG0Hx0YBkagFM7MH1PP6ZCiM3++meXjya0xIRls8VFFNB3pEHbcLMIBpe
         5ZHg==
X-Gm-Message-State: APjAAAUejo2JYuRymq7xO9/9b8GtUkxk+5sI/WPl4P6G1413o1HfTBRk
        MkobBhX4ZIi8bsuV+R13D1Y=
X-Google-Smtp-Source: APXvYqzjvhNhpB3fbGbSjIJeWrf2zXKQ308DX3JNwF8gEk9FxFMPmCYBKNWFt8BhgRPPMdphkVpg9Q==
X-Received: by 2002:a5d:6542:: with SMTP id z2mr10908105wrv.237.1552052254970;
        Fri, 08 Mar 2019 05:37:34 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:34 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 40/46] tools/lib/traceevent: Man page for tep_data_lat_fmt()
Date:   Fri,  8 Mar 2019 15:36:48 +0200
Message-Id: <20190308133654.21264-41-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_data_lat_fmt()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-record_lat.txt              | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record_lat.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-record_lat.txt b/tools/lib/traceevent/Documentation/libtraceevent-record_lat.txt
new file mode 100644
index 000000000000..f4e37b186f61
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-record_lat.txt
@@ -0,0 +1,77 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_data_lat_fmt - Parses the data for the latency format.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+void *tep_data_lat_fmt*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_);
+--
+DESCRIPTION
+-----------
+The _tep_data_lat_fmt()_ function parses out the latency format (interrupts
+disabled, need rescheduling, in hard/soft interrupt, preempt count and
+lock depth) from _record_ and places it into the _s_.  The _tep_ argument is
+the trace event parser context.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep = tep_alloc();
+struct trace_seq seq;
+trace_seq_init(&seq);
+...
+void process_record(struct tep_record *record)
+{
+	/* Place latency information in the seq */
+	tep_data_lat_fmt(tep, &seq, record);
+}
+...
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences related APIs.
+	Trace sequences are used to allow a function to call several other functions
+	to create a string of data to use.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_,_tep_set_latency_format(3)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1

