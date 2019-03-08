Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9C2C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A76272087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfCHNhQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:16 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34912 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfCHNhQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:16 -0500
Received: by mail-wr1-f67.google.com with SMTP id t18so21413240wrx.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TWz/5aF5spJM+gmYokY/ByED7c9k7wibH0kdIAxPq4s=;
        b=pw6Yn6FlyVj+H0QF12aPzqHVHasYNYZkcGiJNBdy33GjsxS0KS9FMsZhIojGwGZA9t
         Vd2fFNKO34J7gaGvOIv3alQrSKmZTETv4cX/LCpA97LeQeCOtM4EdXT2ZCN+UX0n60gI
         x0t0rr46JB4X9r39i/oXRD9rBOzHQb34h/U3ZdNao+dMd+pULi1iZC4WX65xNo/i4/0u
         I8vlEE0YS84d1IFCN8ntsRsVkhasr0fvpkmnt2REHUw0VBllVZtw87D0VF4io26Ndedi
         zz22l7uZYh6zMyR0JuBveKE0kNInUmP/Yms5pS08DjWIKl7Ktr6V5CxtODj2UyzVWkbT
         DW8w==
X-Gm-Message-State: APjAAAUlctHf5nzcCF7hW8VwaCpllIdqBnbjV8mfnKiPOCH6NYJm+49M
        /h3sRWA3yLidNWJG0Iu1VljqjTsw
X-Google-Smtp-Source: APXvYqxWYYuKDNSVa6zG0b+vHEmEkLv3e7XMdJ1dgfdZjQWEJ7uDLulpXhIj4QdTNH5K9PtqpRa9qg==
X-Received: by 2002:adf:c7c6:: with SMTP id y6mr10820805wrg.217.1552052234558;
        Fri, 08 Mar 2019 05:37:14 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:13 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 18/46] tools/lib/traceevent: Man pages for tep_find_event(), tep_find_event_by_name() and tep_find_event_by_record()
Date:   Fri,  8 Mar 2019 15:36:26 +0200
Message-Id: <20190308133654.21264-19-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_find_event(), tep_find_event_by_name()
and tep_find_event_by_record() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_find.txt              | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
new file mode 100644
index 000000000000..961309f24491
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
@@ -0,0 +1,99 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_find_event,tep_find_event_by_name,tep_find_event_by_record - Find events by given key.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_, int _id_);
+struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:[*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
+struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_record_);
+--
+
+DESCRIPTION
+-----------
+This set of functions can be used to search for an event, based on a given
+criteria. All functions require a pointer to a _tep_, trace event parser context.
+
+The _tep_find_event()_ function searches for an event by given event _id_.
+
+The tep_find_event_by_name()_ function searches for an event by given
+event _name_, under the system _sys_. If the _sys_ is NULL (not specified),
+the first event with _name_ is returned.
+
+The tep_find_event_by_record()_ function searches for an event from a given
+_record_.
+
+RETURN VALUE
+------------
+All these functions return a pointer to the found event, or NULL if there is no
+such event.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_event *event;
+
+event = tep_find_event(tep, 1857);
+if (event == NULL) {
+	/* There is no event with ID 1857 */
+}
+
+event = tep_find_event_by_name(tep, "kvm", "kvm_exit");
+if (event == NULL) {
+	/* There is no kvm_exit event, from kvm system */
+}
+
+void event_from_record(struct tep_record *record)
+{
+ struct tep_event *event = tep_find_event_by_record(tep, record);
+	if (event == NULL) {
+		/* There is no event from given record */
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

