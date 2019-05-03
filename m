Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EFCC43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3B82206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfECJLk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43715 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfECJLk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id a12so6865400wrq.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lOsh7yjFkyid7emQ5kYbF8wd4NSvXwJPDsEaULG/B+Q=;
        b=coquupqhr3fvOI7q8YTeVK2XZrPIl7h9YsEtWvNDFjOOzJ2RML/1UhpfPfAMn6Ebo0
         Iw501YubLpPUnKWbl+ZAEb/3jcvRIPcZ1u6R+OzGg9PmEXIao23x+Y5w0YP09bFzvN+6
         mXStxE2EEibxxF58qA6lf95nHSRjumpgEwjSydboEnnyUBOoBTYfxscdUOXG4nOeNcMY
         yLzZaRfZkmTXwfyrJ3HHt2evXsdfP6T7fdK5OVPv7LSLwTu0fY+MTqOCa4GHtF2dTyFU
         IJm5u7RMO+kUKZZXyZSODSEd2QXZvkksqUQE8jTepQ4IgdVvCtqOPqeptQRnIQvXhYG2
         XZ9g==
X-Gm-Message-State: APjAAAW2ZKSfB7FRoUYH+Zlg7kBQq8vVJ/gFEiyMq84aV1AbIn6QTYcl
        np4RE61POtZINgCLZFQsBP4=
X-Google-Smtp-Source: APXvYqzQJrSRN5cjl5G9TARNB6OHrMouRXTUBFiriLzI1YFtSg6C4V9t8JgAV9sCQ+T9X27p6ugWoQ==
X-Received: by 2002:a5d:4942:: with SMTP id r2mr5850639wrs.159.1556874698739;
        Fri, 03 May 2019 02:11:38 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:38 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 21/26] tools/lib/traceevent: Man pages for event fields APIs
Date:   Fri,  3 May 2019 12:11:14 +0300
Message-Id: <20190503091119.23399-22-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_event_common_fields(),
  tep_event_fields()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-fields.txt    | 105 ++++++++++++++++++
 1 file changed, 105 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-fields.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-fields.txt b/tools/lib/traceevent/Documentation/libtraceevent-fields.txt
new file mode 100644
index 000000000000..1ccb531d5114
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-fields.txt
@@ -0,0 +1,105 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_event_common_fields, tep_event_fields - Get a list of fields for an event.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_format_field pass:[*]pass:[*]*tep_event_common_fields*(struct tep_event pass:[*]_event_);
+struct tep_format_field pass:[*]pass:[*]*tep_event_fields*(struct tep_event pass:[*]_event_);
+--
+
+DESCRIPTION
+-----------
+The _tep_event_common_fields()_ function returns an array of pointers to common
+fields for the _event_. The array is allocated in the function and must be freed
+by free(). The last element of the array is NULL.
+
+The _tep_event_fields()_ function returns an array of pointers to event specific
+fields for the _event_. The array is allocated in the function and must be freed
+by free(). The last element of the array is NULL.
+
+RETURN VALUE
+------------
+Both _tep_event_common_fields()_ and _tep_event_fields()_ functions return
+an array of pointers to tep_format_field structures in case of success, or
+NULL in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+int i;
+struct tep_format_field **fields;
+struct tep_event *event = tep_find_event_by_name(tep, "kvm", "kvm_exit");
+if (event != NULL) {
+	fields = tep_event_common_fields(event);
+	if (fields != NULL) {
+		i = 0;
+		while (fields[i]) {
+			/*
+			  walk through the list of the common fields
+			  of the kvm_exit event
+			*/
+			i++;
+		}
+		free(fields);
+	}
+	fields = tep_event_fields(event);
+	if (fields != NULL) {
+		i = 0;
+		while (fields[i]) {
+			/*
+			  walk through the list of the event specific
+			  fields of the kvm_exit event
+			*/
+			i++;
+		}
+		free(fields);
+	}
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

