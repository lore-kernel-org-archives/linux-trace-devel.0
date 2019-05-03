Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E1CC43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16635206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfECJLY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38395 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfECJLY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id f2so890338wmj.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e4nfR029Vx9Sxtn584a4ZhzDlT3wYbjBbk492i8E7p4=;
        b=JiAUOhlICFYZHK1W6iI7SUYmgN8TYic7n6VGj5sXCtDTj223bKe3rYtmh7vetC8/Ex
         4pfUdIrbxwDP+UN4wcXnb9NYmp7KfPh1zxR1LrT2vB41v4RXKZzn1MumlY7Ow5pqMORB
         FM+DThhw3qwNkGXSMuPu9EK05W/rZZiovNQ0RJEpwnBl4MVJOtBtqmz4Kc6cyJ+oqWoQ
         g3PEa1LFtHJMKLHb+WII9LMDj0QYPNKHgbBh4rzfyg+QQWJC3aiUqU671zwsTfTQzZhL
         ZZV1xt6Z8c2wpNsAArc7M8vY3XztZHHBQIp3Mz8e1lyEx+KfS8TjDyeCyVxAWDTzOOtE
         CzEQ==
X-Gm-Message-State: APjAAAUf89xO0Ga8OK5w55EA9+GJ/1IvtBoBq4m3CCPSjEweUjDdKmKg
        RC7u84lf8MJ2LWxThk53CxFe10z2
X-Google-Smtp-Source: APXvYqybjq0IZpJhgvTHLP7klhO2uBNPBeebWhSA1FreHTXGo8zPXnsZXkp9Mgjk2ilZkwO3nDhWJg==
X-Received: by 2002:a1c:5f42:: with SMTP id t63mr5140252wmb.94.1556874681497;
        Fri, 03 May 2019 02:11:21 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:20 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 00/26] Libtraceevent MAN pages
Date:   Fri,  3 May 2019 12:10:53 +0300
Message-Id: <20190503091119.23399-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v6 changes:
  - Addressed Steven Rostedt comments.
  - Deleted Man page for tep_register_trace_clock(), this API will be removed
    from the library
  - Removed following man pages from the series, as those APIs will be changed:
	"Man pages for libtraceevent event print related APIs"
	"Man pages for tep plugins APIs"
	"Man pages for "latency format" APIs"

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

Tzvetomir Stoyanov (26):
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
  tools/lib/traceevent: Man pages for event handler APIs
  tools/lib/traceevent: Man pages for function related libtraceevent 
    APIs
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
  tools/lib/traceevent: Man pages for APIs, used to extract common
    fields from a record
  tools/lib/traceevent: Man pages for trace sequences APIs

 tools/lib/traceevent/Documentation/Makefile   | 208 +++++++++++++++++
 .../traceevent/Documentation/asciidoc.conf    | 120 ++++++++++
 .../Documentation/libtraceevent-commands.txt  | 153 +++++++++++++
 .../Documentation/libtraceevent-cpus.txt      |  77 +++++++
 .../libtraceevent-endian_read.txt             |  78 +++++++
 .../libtraceevent-event_find.txt              | 103 +++++++++
 .../Documentation/libtraceevent-event_get.txt |  99 +++++++++
 .../libtraceevent-event_list.txt              | 122 ++++++++++
 .../libtraceevent-field_find.txt              | 118 ++++++++++
 .../libtraceevent-field_get_val.txt           | 122 ++++++++++
 .../libtraceevent-field_print.txt             | 126 +++++++++++
 .../libtraceevent-field_read.txt              |  81 +++++++
 .../Documentation/libtraceevent-fields.txt    | 105 +++++++++
 .../libtraceevent-file_endian.txt             |  91 ++++++++
 .../Documentation/libtraceevent-filter.txt    | 209 ++++++++++++++++++
 .../Documentation/libtraceevent-func_apis.txt | 183 +++++++++++++++
 .../Documentation/libtraceevent-func_find.txt |  88 ++++++++
 .../Documentation/libtraceevent-handle.txt    | 101 +++++++++
 .../libtraceevent-header_page.txt             | 102 +++++++++
 .../libtraceevent-host_endian.txt             | 104 +++++++++
 .../Documentation/libtraceevent-long_size.txt |  78 +++++++
 .../Documentation/libtraceevent-page_size.txt |  82 +++++++
 .../libtraceevent-parse_event.txt             |  90 ++++++++
 .../libtraceevent-parse_head.txt              |  82 +++++++
 .../libtraceevent-record_parse.txt            | 137 ++++++++++++
 .../libtraceevent-reg_event_handler.txt       | 156 +++++++++++++
 .../libtraceevent-reg_print_func.txt          | 155 +++++++++++++
 .../Documentation/libtraceevent-set_flag.txt  | 104 +++++++++
 .../Documentation/libtraceevent-strerror.txt  |  84 +++++++
 .../Documentation/libtraceevent-tseq.txt      | 158 +++++++++++++
 .../Documentation/libtraceevent.txt           | 203 +++++++++++++++++
 .../traceevent/Documentation/manpage-1.72.xsl |  14 ++
 .../traceevent/Documentation/manpage-base.xsl |  35 +++
 .../Documentation/manpage-bold-literal.xsl    |  17 ++
 .../Documentation/manpage-normal.xsl          |  13 ++
 .../Documentation/manpage-suppress-sp.xsl     |  21 ++
 tools/lib/traceevent/Makefile                 |  33 +++
 37 files changed, 3852 insertions(+)
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

-- 
2.20.1

