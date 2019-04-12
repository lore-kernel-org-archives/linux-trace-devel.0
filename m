Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21D6C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F18D2084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfDLNiP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35009 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfDLNiP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id y197so11094964wmd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f6YSI+53BtyLl2Zj6KVyS+22HMMY6WmcXqbUOR2YO6Q=;
        b=GMUOl0sRK37BbQtf0xksXVUEFmPeriY489WbwD4TiRgY7P1GRRYyAfMeOvsP9pVGtm
         dmwxsZbHlJQ6MAb6+DUxzGpHyFYqU/J9GTZL1DibdoxzdU7oVTciyJXFZIi536wN0ytH
         XldLAhTRoNSvjibHLdLIaoi8fMgyG6Bkar0ubWllVRmHetH3ICc6ULapJhI02DzV9+Bq
         f09nQRALySgROsYQ3UGmPK+IovoTqRpgVH/jTLauS7Ym+pHHqyjChXcuZinrZ9QoGUN9
         Eh2+oW894l4VuluPb5X0mZR6bSh+cJYD6JnK1Dz+h6pndrjMYh2hVGZ/5EXb64JAV22J
         HAHQ==
X-Gm-Message-State: APjAAAVhIVwTy1HA1QggCwCJSAeEC1YCh5Vtw1aVPrBOFzfWNHHBOfLz
        qn3AWxVkEULyG6dELFZW4MCKZB9c
X-Google-Smtp-Source: APXvYqyg5UfbhEe0yON5NqkO+ob1V4VEOo96i/DHh5f1VF8mPe0w/Un8JETCG30iPfkWAhDJ4jQbWA==
X-Received: by 2002:a1c:f115:: with SMTP id p21mr10956822wmh.93.1555076292736;
        Fri, 12 Apr 2019 06:38:12 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:11 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 00/30]  Libtraceevent MAN pages
Date:   Fri, 12 Apr 2019 16:37:41 +0300
Message-Id: <20190412133811.15878-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v5 changes:
  - Grouped logically related APIs into single man page.
  - Updated the man pages, to be in sync with the latest libtracevent APIs cleanup.
  - Changed descriptions in some man pages, suggested by Steven Rostedt.

 v4 changes:
  - Addressed Steven Rostedt comments.
  - Removed trailing whitespace.

 v3 changes:
  - Combines all man page related patches into one series. 
  - Removes any dependencies between man page related patches.
    and patches related to the APIs implementation.
]

This patch series includes implementation of libtraceevent
man pages, describing all APIs of the library.

Tzvetomir Stoyanov (30):
  tools/lib/traceevent: Implement libtraceevent man pages
  tools/lib/traceevent: Add support for man pages with multiple names
  tools/lib/traceevent: libtraceevent man pages for tep_handler related
    APIs
  tools/lib/traceevent: Man page for header_page APIs
  tools/lib/traceevent: Man page for get/set cpus APIs
  tools/lib/traceevent: Man page for file endian APIs
  tools/lib/traceevent: Man page for host endian APIs
  tools/lib/traceevent: Man page for page size APIs
  tools/lib/traceevent: Man page for tep_strerror()
  tools/lib/traceevent: Man page for tep_register_trace_clock()
  tools/lib/traceevent: Man pages for event handler APIs
  tools/lib/traceevent: Man pages for function related libtraceevent 
    APIs
  tools/lib/traceevent: Man pages for registering print function
  tools/lib/traceevent: Man page for tep_read_number()
  tools/lib/traceevent: Man pages for event find APIs
  tools/lib/traceevent: Man page for list events APIs
  tools/lib/traceevent: Man pages for libtraceevent event print related
    APIs
  tools/lib/traceevent: Man pages for libtraceevent event get APIs
  tools/lib/traceevent: Man pages find field APIs
  tools/lib/traceevent: Man pages get field value APIs
  tools/lib/traceevent: Man pages for print field APIs
  tools/lib/traceevent: Man page for tep_read_number_field()
  tools/lib/traceevent: Man pages for event fields APIs
  tools/lib/traceevent: Man pages for event filter APIs
  tools/lib/traceevent: Man pages for parse event APIs
  tools/lib/traceevent: Man page for tep_parse_header_page()
  tools/lib/traceevent: Man pages for tep plugins APIs
  tools/lib/traceevent: Man pages for "latency format" APIs
  tools/lib/traceevent: Man pages for APIs, used to extract common
    fields from a record
  tools/lib/traceevent: Man pages for trace sequences APIs

 tools/lib/traceevent/Documentation/Makefile   | 208 +++++++++++++++++
 .../traceevent/Documentation/asciidoc.conf    | 120 ++++++++++
 .../Documentation/libtraceevent-commands.txt  | 153 +++++++++++++
 .../Documentation/libtraceevent-cpus.txt      |  77 +++++++
 .../libtraceevent-endian_read.txt             |  78 +++++++
 .../libtraceevent-event_find.txt              | 101 +++++++++
 .../Documentation/libtraceevent-event_get.txt |  99 +++++++++
 .../libtraceevent-event_list.txt              | 121 ++++++++++
 .../libtraceevent-event_print.txt             | 138 ++++++++++++
 .../libtraceevent-field_find.txt              | 118 ++++++++++
 .../libtraceevent-field_get_val.txt           | 121 ++++++++++
 .../libtraceevent-field_print.txt             | 121 ++++++++++
 .../libtraceevent-field_read.txt              |  80 +++++++
 .../Documentation/libtraceevent-fields.txt    | 105 +++++++++
 .../libtraceevent-file_endian.txt             |  91 ++++++++
 .../Documentation/libtraceevent-filter.txt    | 210 ++++++++++++++++++
 .../Documentation/libtraceevent-func_apis.txt | 175 +++++++++++++++
 .../Documentation/libtraceevent-func_find.txt |  88 ++++++++
 .../Documentation/libtraceevent-handle.txt    | 101 +++++++++
 .../libtraceevent-header_page.txt             | 105 +++++++++
 .../libtraceevent-host_endian.txt             | 106 +++++++++
 .../libtraceevent-latency_format.txt          | 154 +++++++++++++
 .../Documentation/libtraceevent-long_size.txt |  78 +++++++
 .../Documentation/libtraceevent-page_size.txt |  80 +++++++
 .../libtraceevent-parse_event.txt             |  90 ++++++++
 .../libtraceevent-parse_head.txt              |  82 +++++++
 .../Documentation/libtraceevent-plugins.txt   |  98 ++++++++
 .../libtraceevent-record_parse.txt            | 137 ++++++++++++
 .../Documentation/libtraceevent-reg_clock.txt |  77 +++++++
 .../libtraceevent-reg_event_handler.txt       | 131 +++++++++++
 .../libtraceevent-reg_print_func.txt          | 155 +++++++++++++
 .../Documentation/libtraceevent-set_flag.txt  | 104 +++++++++
 .../Documentation/libtraceevent-strerror.txt  |  80 +++++++
 .../Documentation/libtraceevent-tseq.txt      | 158 +++++++++++++
 .../Documentation/libtraceevent.txt           | 203 +++++++++++++++++
 .../traceevent/Documentation/manpage-1.72.xsl |  14 ++
 .../traceevent/Documentation/manpage-base.xsl |  35 +++
 .../Documentation/manpage-bold-literal.xsl    |  17 ++
 .../Documentation/manpage-normal.xsl          |  13 ++
 .../Documentation/manpage-suppress-sp.xsl     |  21 ++
 tools/lib/traceevent/Makefile                 |  33 +++
 41 files changed, 4276 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/Makefile
 create mode 100644 tools/lib/traceevent/Documentation/asciidoc.conf
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-commands.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_get.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-fields.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_find.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent.txt
 create mode 100644 tools/lib/traceevent/Documentation/manpage-1.72.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-base.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-normal.xsl
 create mode 100644 tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl

-- 
2.20.1

