Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D6BC04AB3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 240E3217F9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfEJUDG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 16:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727700AbfEJUBJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 16:01:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25812184B;
        Fri, 10 May 2019 20:01:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hPBhZ-0006dO-To; Fri, 10 May 2019 16:01:05 -0400
Message-Id: <20190510195606.537643615@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 15:56:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 00/27] tools/lib/traceevent: Add man pages for most libtraceevent functions
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to complete the libtraceevent into a proper library, Tzvetomir
has been working on creating man pages for all the functions that
are exported for use by applications that will use libtraceevent.

In the process of writing these, we came across a few functions that
need to be reworked, before we can post libtraceevent for distributions
to share. These functions we will be working on and sending patches later
on, with corresponding man pages for them. But for now, the man pages
in this series are for functions we feel are fine as is.

Arnaldo, please pull these patches into your queue.

Thanks!

-- Steve



Tzvetomir Stoyanov (27):
      tools lib traceevent: Remove hard coded install paths from pkg-config file
      tools/lib/traceevent: Implement libtraceevent man pages
      tools/lib/traceevent: Add support for man pages with multiple names
      tools/lib/traceevent: libtraceevent man pages for tep_handler related APIs
      tools/lib/traceevent: Man page for header_page APIs
      tools/lib/traceevent: Man page for get/set cpus APIs
      tools/lib/traceevent: Man page for file endian APIs
      tools/lib/traceevent: Man page for host endian APIs
      tools/lib/traceevent: Man page for page size APIs
      tools/lib/traceevent: Man page for tep_strerror()
      tools/lib/traceevent: Man pages for event handler APIs
      tools/lib/traceevent: Man pages for function related libtraceevent APIs
      tools/lib/traceevent: Man pages for registering print function
      tools/lib/traceevent: Man page for tep_read_number()
      tools/lib/traceevent: Man pages for event find APIs
      tools/lib/traceevent: Man page for list events APIs
      tools/lib/traceevent: Man pages for libtraceevent event get APIs
      tools/lib/traceevent: Man pages find field APIs
      tools/lib/traceevent: Man pages get field value APIs
      tools/lib/traceevent: Man pages for print field APIs
      tools/lib/traceevent: Man page for tep_read_number_field()
      tools/lib/traceevent: Man pages for event fields APIs
      tools/lib/traceevent: Man pages for event filter APIs
      tools/lib/traceevent: Man pages for parse event APIs
      tools/lib/traceevent: Man page for tep_parse_header_page()
      tools/lib/traceevent: Man pages for APIs, used to extract common fields from a record
      tools/lib/traceevent: Man pages for trace sequences APIs

----
 tools/lib/traceevent/Documentation/Makefile        | 207 ++++++++++++++++++++
 tools/lib/traceevent/Documentation/asciidoc.conf   | 120 ++++++++++++
 .../Documentation/libtraceevent-commands.txt       | 153 +++++++++++++++
 .../Documentation/libtraceevent-cpus.txt           |  77 ++++++++
 .../Documentation/libtraceevent-endian_read.txt    |  78 ++++++++
 .../Documentation/libtraceevent-event_find.txt     | 103 ++++++++++
 .../Documentation/libtraceevent-event_get.txt      |  99 ++++++++++
 .../Documentation/libtraceevent-event_list.txt     | 122 ++++++++++++
 .../Documentation/libtraceevent-field_find.txt     | 118 ++++++++++++
 .../Documentation/libtraceevent-field_get_val.txt  | 122 ++++++++++++
 .../Documentation/libtraceevent-field_print.txt    | 126 +++++++++++++
 .../Documentation/libtraceevent-field_read.txt     |  81 ++++++++
 .../Documentation/libtraceevent-fields.txt         | 105 +++++++++++
 .../Documentation/libtraceevent-file_endian.txt    |  91 +++++++++
 .../Documentation/libtraceevent-filter.txt         | 209 +++++++++++++++++++++
 .../Documentation/libtraceevent-func_apis.txt      | 183 ++++++++++++++++++
 .../Documentation/libtraceevent-func_find.txt      |  88 +++++++++
 .../Documentation/libtraceevent-handle.txt         | 101 ++++++++++
 .../Documentation/libtraceevent-header_page.txt    | 102 ++++++++++
 .../Documentation/libtraceevent-host_endian.txt    | 104 ++++++++++
 .../Documentation/libtraceevent-long_size.txt      |  78 ++++++++
 .../Documentation/libtraceevent-page_size.txt      |  82 ++++++++
 .../Documentation/libtraceevent-parse_event.txt    |  90 +++++++++
 .../Documentation/libtraceevent-parse_head.txt     |  82 ++++++++
 .../Documentation/libtraceevent-record_parse.txt   | 137 ++++++++++++++
 .../libtraceevent-reg_event_handler.txt            | 156 +++++++++++++++
 .../Documentation/libtraceevent-reg_print_func.txt | 155 +++++++++++++++
 .../Documentation/libtraceevent-set_flag.txt       | 104 ++++++++++
 .../Documentation/libtraceevent-strerror.txt       |  85 +++++++++
 .../Documentation/libtraceevent-tseq.txt           | 158 ++++++++++++++++
 .../lib/traceevent/Documentation/libtraceevent.txt | 203 ++++++++++++++++++++
 .../lib/traceevent/Documentation/manpage-1.72.xsl  |  14 ++
 .../lib/traceevent/Documentation/manpage-base.xsl  |  35 ++++
 .../Documentation/manpage-bold-literal.xsl         |  17 ++
 .../traceevent/Documentation/manpage-normal.xsl    |  13 ++
 .../Documentation/manpage-suppress-sp.xsl          |  21 +++
 tools/lib/traceevent/Makefile                      |  46 ++++-
 tools/lib/traceevent/libtraceevent.pc.template     |   4 +-
 38 files changed, 3863 insertions(+), 6 deletions(-)
 create mode 100644 tools/lib/traceevent/Documentation/Makefile
 create mode 100644 tools/lib/traceevent/Documentation/asciidoc.conf
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-commands.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_get.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
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
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
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
