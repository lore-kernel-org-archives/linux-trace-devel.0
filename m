Return-Path: <SRS0=Mn5y=NN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730056.outbound.protection.outlook.com ([40.107.73.56]:48320
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbeKCAEt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 20:04:49 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/3] libtraceevent man pages
Date: Fri, 2 Nov 2018 14:57:25 +0000
Message-ID: <20181102145714.25885-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches continues libtraceevent man pages implementation.=20
First two patches improve man pages build process.=20
The last patch implements 5 new man pages, describing 13 libtraceevent APIs

Tzvetomir Stoyanov (3):
  tools/lib/traceevent: Fix libtraceevent/Documentation Makefile
  tools/lib/traceevent: Add support for man pages with multiple names
  tools/lib/traceevent: Implement libtraceevent man pages

 tools/lib/traceevent/Documentation/Makefile   |   2 +-
 .../traceevent/Documentation/asciidoc.conf    |  35 ++++-
 .../Documentation/libtraceevent-commands.txt  | 125 ++++++++++++++++++
 .../Documentation/libtraceevent-handle.txt    |  77 +++++++++++
 .../Documentation/libtraceevent-long_size.txt |  75 +++++++++++
 .../Documentation/libtraceevent-ref.txt       |  84 ++++++++++++
 .../Documentation/libtraceevent-set_flag.txt  |  94 +++++++++++++
 7 files changed, 488 insertions(+), 4 deletions(-)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-comman=
ds.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle=
.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_s=
ize.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-ref.tx=
t
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_fl=
ag.txt

--=20
2.17.2
