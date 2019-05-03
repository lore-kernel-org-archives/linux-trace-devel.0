Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6683C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81BB5206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfECJLg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40725 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfECJLg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so6875794wre.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B+Ei2QhpQrkv3h8J1/NRM3Vibn/+b9Kac0vIj2+fXp8=;
        b=V+y+uYlIvrLp48JFBwdBXT1Jwoicr41Z/tRJrFfEFk0q5j1UHqBHIkwKhDOvIMEAgA
         uTJ3Lz95wLbqOuJe009Sx5YPXWjagSzwDoXGQjXNjL+c92K3hsR+CMRNshNpbrFy3ts8
         Tw6jgyE+/RAkahxXYBak7qk0DsubdejYOgd0mL9+5poqel5AoCXsRqG8H/N/jgyKf/Ly
         0vSJzbUeKbTv2WglC1WiTh63ss1bGNOO0IBgQ/zbShFpwgCkD+TmFC280Pt3QCyNsWCL
         llqk8YM9ZF8qkE02FdQjgAtv+fn+NKEwQGHDox/sal3JZi15MLv9JcZ+Hr9TaAi76J5d
         B2AQ==
X-Gm-Message-State: APjAAAVBXVxKw/BlQJD/e9piNcZl5xDHmd+UBNAHaM7+Ryqs7s0w6zdd
        YQEZNFa2u5EBw2WyGrNb6CppBb/2
X-Google-Smtp-Source: APXvYqyz8CfFQkI8ZjN3zpj0/wSav7niAz3ubuXNASQWfmNTppvRQJJ7ihPSH/JaV5JoG/z7tWqHow==
X-Received: by 2002:a5d:6384:: with SMTP id p4mr5946649wru.208.1556874694675;
        Fri, 03 May 2019 02:11:34 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:34 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 16/26] tools/lib/traceevent: Man pages for libtraceevent event get APIs
Date:   Fri,  3 May 2019 12:11:09 +0300
Message-Id: <20190503091119.23399-17-tstoyanov@vmware.com>
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
  tep_get_event(),
  tep_get_first_event(),
  tep_get_events_count()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-event_get.txt | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_get.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_get.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_get.txt
new file mode 100644
index 000000000000..6525092fc417
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_get.txt
@@ -0,0 +1,99 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_event, tep_get_first_event, tep_get_events_count - Access events.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event pass:[*]*tep_get_event*(struct tep_handle pass:[*]_tep_, int _index_);
+struct tep_event pass:[*]*tep_get_first_event*(struct tep_handle pass:[*]_tep_);
+int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_event()_ function returns a pointer to event at the given _index_.
+The _tep_ argument is trace event parser context, the _index_ is the index of
+the requested event.
+
+The _tep_get_first_event()_ function returns a pointer to the first event.
+As events are stored in an array, this function returns the pointer to the
+beginning of the array. The _tep_ argument is trace event parser context.
+
+The _tep_get_events_count()_ function returns the number of the events
+in the array. The _tep_ argument is trace event parser context.
+
+RETURN VALUE
+------------
+The _tep_get_event()_ returns a pointer to the event located at _index_.
+NULL is returned in case of error, in case there are no events or _index_ is
+out of range.
+
+The _tep_get_first_event()_ returns a pointer to the first event. NULL is
+returned in case of error, or in case there are no events.
+
+The _tep_get_events_count()_ returns the number of the events. 0 is
+returned in case of error, or in case there are no events.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+int i,count = tep_get_events_count(tep);
+struct tep_event *event, *events = tep_get_first_event(tep);
+
+if (events == NULL) {
+	/* There are no events */
+} else {
+	for (i = 0; i < count; i++) {
+		event = (events+i);
+		/* process events[i] */
+	}
+
+	/* Get the last event */
+	event = tep_get_event(tep, count-1);
+}
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

