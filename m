Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F829C10F0C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21B992087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfCHNhW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39585 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfCHNhW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id l12so4941648wrp.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m7Hn7G59mHLmCr/lcwZOu3afUTjfbTYKOGnNqVA3Z+8=;
        b=U6HNGEeP81pTXfpZL7uvVWVsSTstzdSQt/7hbYpxqQICAlmCxVTQHXFr1LXXRW/OQz
         E0vrvCsZLd9t3o0UWQRQ4J5bCwkJ53OpcEKIPiQh7SD0fEvN9tjVdMilD/ReC1fvSxOH
         STmfZs4/R0Jm0UrZg7GWiCafK2bzKog1ohK3u9FUnfYdteDMJW8+RgNi9GqYq4buPx06
         3KrMe3vCVgcyl4I19ScB6xtlS7V3okLlRxf/Xa/ncl9k3PkdfhHBakG9ybpLt0FMUSbC
         D9SgtKLVkrKBORUohAzH8F0zImAIu/Du3k9BWaojVE/WdZQj3gFqen6iwPMq2Aheyc8c
         hTJA==
X-Gm-Message-State: APjAAAXLvozkR7mBnHt4f3TAHr/oDZrneiwD5ihwtz31+KFPFbGMHDIp
        44QyNUTZFe0fEzMltoBa2U1qd82k
X-Google-Smtp-Source: APXvYqxGSNUBNGM4TyoCvJYSafy64YnCVcpCRKw5Twv/4G6YR0mByVEeZbMq2CyykcxduovKKXR8TQ==
X-Received: by 2002:adf:ee4d:: with SMTP id w13mr11213246wro.16.1552052240902;
        Fri, 08 Mar 2019 05:37:20 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:20 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 25/46] tools/lib/traceevent: Man page for tep_read_number_field()
Date:   Fri,  8 Mar 2019 15:36:33 +0200
Message-Id: <20190308133654.21264-26-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_read_number_field()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_read.txt              | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_read.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
new file mode 100644
index 000000000000..0c560c416ac2
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
@@ -0,0 +1,80 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_read_number_field - Reads a number from a raw data.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, const void pass:[*]_data_, unsigned long long pass:[*]_value_);
+--
+
+DESCRIPTION
+-----------
+The _tep_read_number_field()_ function reads the value of the _field_ from the
+raw _data_ and stores it in the _value_. The function sets the _value_ according
+to the endianness of the raw data and the current machine.
+
+RETURN VALUE
+------------
+The _tep_read_number_field()_ function retunrs 0 in case of success, or -1 in
+case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_event *event = tep_find_event_by_name(tep, "timer", "hrtimer_start");
+...
+void process_record(struct tep_record *record)
+{
+	unsigned long long pid;
+	struct tep_format_field *field_pid = tep_find_common_field(event, "common_pid");
+
+	if (tep_read_number_field(field_pid, record->data, &pid) != 0) {
+		/* Failed to get "common_pid" value */
+	}
+}
+...
+--
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
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

