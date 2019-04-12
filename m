Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98658C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A7B2084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfDLNig (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54793 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfDLNif (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id c1so11282090wml.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lOsh7yjFkyid7emQ5kYbF8wd4NSvXwJPDsEaULG/B+Q=;
        b=gBW6BOckNiBHbXdKBeRgWdTx8rBtIxBM8A94lutwpOfcpSoTc4ZjwGykCatm1baUD+
         QGJtTtsfH1Ixj6SxOTfsPtl7MaRGxEiUOpnSyp8KDUv456F+vjPFVWsXwLCP7a6wFK1+
         tX5rPel4u620Jy9Djlruiz4Q60c0qtZ0D05gR7lUG+eT29ILAG7jv/S84IfHYv2JHLpS
         6KyOTT3ib91Ge4Q4rZ4msRn5z1GIAFSQCa+K5m5dV6c3oAZHg9bSV1gMfEmeAVi8SN7U
         diyACSWDTbL58nw1pAe/E2PE1Wla5phjwdsLkqzmrGqbA5LhGmi6jAA/pZE6zQ8w9aoy
         W/Kw==
X-Gm-Message-State: APjAAAVSclbKoiMM70xO2bE6dtQnkYs4dON5GkuPtjrrCJVc4ElWr8aD
        U8Um4YmM2OVdIURZek2CDcV4H14L
X-Google-Smtp-Source: APXvYqzKzCCOa/FdD0UaUSxmL51TLQLH+NXbHhK+nKBJTht3DVM4vMYga00GbjgJY3UG+zZICV+69w==
X-Received: by 2002:a7b:c743:: with SMTP id w3mr10964194wmk.75.1555076314065;
        Fri, 12 Apr 2019 06:38:34 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:33 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 23/30] tools/lib/traceevent: Man pages for event fields APIs
Date:   Fri, 12 Apr 2019 16:38:04 +0300
Message-Id: <20190412133811.15878-24-tstoyanov@vmware.com>
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

