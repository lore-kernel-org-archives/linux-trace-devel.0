Return-Path: <SRS0=VnmA=N7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690070.outbound.protection.outlook.com ([40.107.69.70]:20160
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeKUAj2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Nov 2018 19:39:28 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 0/3] libtraceevent: Added support for pkg-config and few
 other fixes related to transfoming traceevent into a library
Date: Tue, 20 Nov 2018 14:10:06 +0000
Message-ID: <20181120140953.30315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Added support for pkg-config, which makes possible the library to be detect=
ed by autoconfig.
Implemented new API tep_ref_get(), used by applications to get the tep hand=
le reference count.
Install trace-seq.h header file, which is part of the library API.=20

[v2 of the patch: renamed tep_ref_get -> tep_get_ref, included v2 of the "A=
dded support for pkg-config" patch]

Tzvetomir Stoyanov (3):
  tools/lib/traceevent: Implemented new API tep_get_ref()
  tools/lib/traceevent: Added support for pkg-config
  tools/lib/traceevent: Install trace-seq.h API header file

 tools/lib/traceevent/Makefile                 | 27 ++++++++++++++++---
 tools/lib/traceevent/event-parse.c            |  7 +++++
 tools/lib/traceevent/event-parse.h            |  1 +
 .../lib/traceevent/libtraceevent.pc.template  | 10 +++++++
 4 files changed, 42 insertions(+), 3 deletions(-)
 create mode 100644 tools/lib/traceevent/libtraceevent.pc.template

--=20
2.19.1
