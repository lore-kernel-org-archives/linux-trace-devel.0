Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F50AC04AAC
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB3B206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfECJLe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39295 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfECJLe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id a9so6881641wrp.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A5s9K+7KE/iJ2C5ypPOQFZuBFAwMnMhpdfofRurpHMA=;
        b=NVya2p2fPeDEn1UAQMuvD8bVIRBDKJmgmD4XVZ4dvii11S/otcoBzfn+X7hNccV1B0
         3lxqiw6o2HuglqNg8IY9VMq9loZc3gviVE/16goVNyarh0ZQZSCQyf60UAXusvGw7N70
         5O2Z4BJlQTNZQLtNEjmcOYLm7QdF0KiR/t+VHC+g9w2nv1ORlg2TBNBotvTBVXgboCad
         iP9fy0/ALT41ezdVLzU9tyVH94wdsJVqBnXEt8Z8BXXuGE9C8n4Xe7XWG9jh5Kjy2N9u
         xwPkYzeCJNpjFvF4pnGNl89s3FrMO7xV5m2bvTtXRCZz9O847HjSw6LmX7PRDdTg21iJ
         I+aQ==
X-Gm-Message-State: APjAAAUFOOvG0k2wSzHu3rKKAvQBOlBinE/tZhlS+nGZhn/1Nu5GDjtp
        XFbkrVQebnPXLVQge3hDMOvYH99K
X-Google-Smtp-Source: APXvYqyalljepCRmoxQha6kDf6am4lO54BzfjE1eToftiY6wSzK7E6tKPX7kAp2Il+MvdfU1wc26pw==
X-Received: by 2002:adf:a202:: with SMTP id p2mr6178110wra.166.1556874693201;
        Fri, 03 May 2019 02:11:33 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:32 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 14/26] tools/lib/traceevent: Man pages for event find APIs
Date:   Fri,  3 May 2019 12:11:07 +0300
Message-Id: <20190503091119.23399-15-tstoyanov@vmware.com>
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
  tep_find_event()
  tep_find_event_by_name()
  tep_find_event_by_record()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_find.txt              | 103 ++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
new file mode 100644
index 000000000000..7bc062c9f76f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
@@ -0,0 +1,103 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_find_event,tep_find_event_by_name,tep_find_event_by_record -
+Find events by given key.
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
+criteria. All functions require a pointer to a _tep_, trace event parser
+context.
+
+The _tep_find_event()_ function searches for an event by given event _id_. The
+event ID is assigned dynamically and can be viewed in event's format file,
+"ID" field.
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

