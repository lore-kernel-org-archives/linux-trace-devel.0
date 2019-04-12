Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EFFC282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E802084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfDLNie (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39495 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfDLNie (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id j9so12012510wrn.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XCwqz38+6Na1cuazbbZfVOCxZtol9JZD0vkz8i0Dekc=;
        b=HRhL5ekUCWERFG7zjO0y6FPeOuBeBSZg/qCqSOav9xFHgfNC5/nfQHlf6JX2ZWuC/g
         je06oRMzdU2w9wDZc+ivsXF3ToDaYdUi0t67DGk1bl4kdgZtNrk/R0QdR3b8Ikxy39fi
         iuJIbbiPQSPpzEIAFBZjiY7jr3urXMdSebXyyVI2JVzDX3/tPh9LzXXPugiUixM5qW4q
         9t8VaDIBUfbd5odlepaAPKPR//hIPcLsVwyl/0JjqXv34xjHoApoc1zaA7ueevX6En9a
         3V9Kx/5IGWqVxmWEHXXILHlsdzVo99nP7X9/0V7PRdyX8A/1YwHHfYjHZIZfsDGwAWm9
         SYEg==
X-Gm-Message-State: APjAAAW/WWDQPOG6wZNvdggBk/IybtVrGr0KNQylvmVLRPii7lwUdfG9
        zd1L5i/HhYtT1ptWnEfxzZY=
X-Google-Smtp-Source: APXvYqw+r++6y65F5JUXaJQ7/36wEiXckInMyPvLL/IPPmPSkR+uaHn9LoomveBIjaI7yHsSatutrQ==
X-Received: by 2002:a5d:458f:: with SMTP id p15mr35304045wrq.188.1555076313025;
        Fri, 12 Apr 2019 06:38:33 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:32 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 22/30] tools/lib/traceevent: Man page for tep_read_number_field()
Date:   Fri, 12 Apr 2019 16:38:03 +0300
Message-Id: <20190412133811.15878-23-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for libtraceevent API tep_read_number_field().

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

