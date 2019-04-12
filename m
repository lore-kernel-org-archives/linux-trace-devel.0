Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4021C282CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF15C2084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfDLNid (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:33 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35882 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfDLNid (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id h18so11090349wml.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1bQE3TTFSmDOY6FHgV61Pevw3gusRyfrEHXS0IauMjA=;
        b=OMdStb0Sa28PFCH140UqzYt24xj7aDd7jbk5C19+hOHvMGJOoJDyHzZbWh/TO/oocZ
         VnND/vljVqQXes0jY/Svq6f5yNGViH1+y4NBxdtmC6VnZBitw8YDYkO6M/mYgQmig76a
         rT4B7OOmALO6fJPFt07B4pJEnOVSzoMxzFTHnxV5yGqtuMjjicTP46P7JAbFN+Y8mWH3
         9DTpO6cDRVOrkBHlfQzdkclkgfDH+R4ofTePJFfX62u4TdnIwYXUQ8MtDxoTRtcpWfJU
         /xdfpMjYkb1/prCAXrvvnV7evvzZVgvhpIpl0DSJm93LHYfxksSjNmodCUP/Ln/5VXmz
         OD3Q==
X-Gm-Message-State: APjAAAWZLo9xWydUa5cF6CNib9ZcnoOx3XRVL82S6vdDcIjXy9t+uS/H
        D62x8hoXR2I2wj5eJDN+PeYao7bW
X-Google-Smtp-Source: APXvYqzI53gzhvRlusxLjTNd2U8DJsH6RkgOftLQ4SyQAeb/aXbhKuWcLrqUMZqGaqWPXHQaKORbMw==
X-Received: by 2002:a1c:4187:: with SMTP id o129mr11007739wma.57.1555076311154;
        Fri, 12 Apr 2019 06:38:31 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:30 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 20/30] tools/lib/traceevent: Man pages get field value APIs
Date:   Fri, 12 Apr 2019 16:38:01 +0300
Message-Id: <20190412133811.15878-21-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_get_any_field_val(),
  tep_get_common_field_val(),
  tep_get_field_val(),
  tep_get_field_raw()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_get_val.txt           | 121 ++++++++++++++++++
 1 file changed, 121 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
new file mode 100644
index 000000000000..b71b407b23e9
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
@@ -0,0 +1,121 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_any_field_val, tep_get_common_field_val, tep_get_field_val,
+tep_get_field_raw - Get value of a field.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *tep_get_any_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+int *tep_get_common_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+int *tep_get_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+void pass:[*]*tep_get_field_raw*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int pass:[*]_len_, int _err_);
+--
+
+DESCRIPTION
+-----------
+These functions can be used to find a field and retrieve its value.
+
+The _tep_get_any_field_val()_ function searches in the _record_ for a field
+with _name_, part of the _event_. If the field is found, its value is stored in
+_val_. If there is an error and _err_ is not zero, then an error string is
+written into _s_.
+
+The _tep_get_common_field_val()_ function does the same as
+_tep_get_any_field_val()_, but searches only in the common fields. This works
+for any event as all events include the common fields.
+
+The _tep_get_field_val()_ function does the same as _tep_get_any_field_val()_,
+but searches only in the event specific fields.
+
+The _tep_get_field_raw()_ function searches in the _record_ for a field with
+_name_, part of the _event_. If the field is found, a pointer to its raw data
+is returned. The size of the data is stored in _len_. If there is an error and
+_err_ is not zero, then an error string is written into _s_.
+
+RETURN VALUE
+------------
+The _tep_get_any_field_val()_, _tep_get_common_field_val()_ and
+_tep_get_field_val()_ functions return 0 on success, or -1 in case of an error.
+
+The _tep_get_field_raw()_ function returns a pointer to field's raw data, and
+places the length of this data in _len_. In case of an error NULL is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_event *event = tep_find_event_by_name(tep, "kvm", "kvm_exit");
+...
+void process_record(struct tep_record *record)
+{
+	int len;
+	char *comm;
+	struct tep_event_format *event;
+	unsigned long long val;
+
+	event = tep_find_event_by_record(pevent, record);
+	if (event != NULL) {
+		if (tep_get_common_field_val(NULL, event, "common_type",
+		 			     record, &val, 0) == 0) {
+			/* Got the value of common type field */
+		}
+		if (tep_get_field_val(NULL, event, "pid", record, &val, 0) == 0) {
+			/* Got the value of pid specific field */
+		}
+		comm = tep_get_field_raw(NULL, event, "comm", record, &len, 0);
+		if (comm != NULL) {
+			/* Got a pointer to the comm event specific field */
+		}
+	}
+}
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences
+	related APIs. Trace sequences are used to allow a function to call
+	several other functions to create a string of data to use.
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

