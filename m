Return-Path: <SRS0=W9qh=MK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:51628
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbeI1NmV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Sep 2018 09:42:21 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] libtraceevent: Added support for pkg-config and few other fixes related to transfoming traceevent into a library
Date: Fri, 28 Sep 2018 10:19:37 +0300
Message-Id: <20180928071940.29810-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Added support for pkg-config, which makes possible the library to be detected by autoconfig.
Implemented new API tep_ref_get(), used by applications to get the tep handle reference count.
Install trace-seq.h header file, which is part of the library API. 

Tzvetomir Stoyanov (3):
  tools/lib/traceevent: Implemented new API tep_ref_get()
  tools/lib/traceevent: Added support for pkg-config
  tools/lib/traceevent: Install trace-seq.h API header file

 tools/lib/traceevent/Makefile                 | 27 ++++++++++++++++---
 tools/lib/traceevent/event-parse.c            |  7 +++++
 tools/lib/traceevent/event-parse.h            |  1 +
 .../lib/traceevent/libtraceevent.pc.template  | 10 +++++++
 4 files changed, 42 insertions(+), 3 deletions(-)
 create mode 100644 tools/lib/traceevent/libtraceevent.pc.template

-- 
2.17.1
