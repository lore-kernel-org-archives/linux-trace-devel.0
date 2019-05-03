Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E33C004C9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CF7D206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfECJLk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35114 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfECJLj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id y197so5824273wmd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n2QFBROvX+ZkyelCN4SBkujc7Waj64W+cUz3iKlUioI=;
        b=L2+2v7bAVPEmE2xdJId/4MpHwPEzhCZVD9Rmdr6gUru98xO3xuYa8bsqSYCyaL+d1W
         JSIb32CYy/DLfFgDXxlUkGo2Y0fLCDp5kRPcktucdKX3ZTM1B6EEP3vdRPHL3rnYdKvp
         3YQj4Oxs4zLW5RYfAywzVswoVd1JL36eWT41KWSVF8jvWtrKK3jpWowm7qG5KT4CmvOY
         MnT3avYapsOEfGvX/1q0QnR9wXAunrRjaxsCO+ejIyM1AVq0H/bOeBhLM1DbJ/N5Axod
         7ZV+i+sVrGadBV8or/llRiAFOY9B8Td42+IYrAAEWXHwo6RNX53/ilmgn6VMZhE+VjCH
         kA8A==
X-Gm-Message-State: APjAAAUqLa9lv+DY7PW3dSCG3N4YzZmQJjQ2NEQmwHv2kjR1oBKOTn4O
        x8VVOLRi6tM1BzS2va5FecM=
X-Google-Smtp-Source: APXvYqw61HEMFr4kqWofnlanQNR6sLBAWLKyGSVhU2Vyacz1UY79+Vuxbex+7aVMmpNczdu27Mk6yg==
X-Received: by 2002:a05:600c:2206:: with SMTP id z6mr5779736wml.80.1556874697932;
        Fri, 03 May 2019 02:11:37 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:37 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 20/26] tools/lib/traceevent: Man page for tep_read_number_field()
Date:   Fri,  3 May 2019 12:11:13 +0300
Message-Id: <20190503091119.23399-21-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for libtraceevent API tep_read_number_field().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_read.txt              | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_read.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
new file mode 100644
index 000000000000..64e9e25d3fd9
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
@@ -0,0 +1,81 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_read_number_field - Reads a number from raw data.
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
+to the endianness of the raw data and the current machine and stores it in
+_value_.
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

