Return-Path: <SRS0=lo60=NR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710048.outbound.protection.outlook.com ([40.107.71.48]:16352
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388447AbeKFWqC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Nov 2018 17:46:02 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/7] libtracevent man pages
Date: Tue, 6 Nov 2018 13:20:48 +0000
Message-ID: <20181106132035.7692-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches implement 7 libtraceveent man pages,
describing APIs:
tep_get_header_page_size(), tep_get_cpus(), tep_set_cpus(),
tep_is_file_bigendian(), tep_set_file_bigendian(),
tep_is_host_bigendian(), tep_set_host_bigendian(),
tep_is_latency_format(), and tep_set_latency_format(),
tep_get_page_size(), tep_set_page_size()
and tep_strerror().

Tzvetomir Stoyanov (7):
  tools/lib/traceevent: Implement libtraceevent man pages
  tools/lib/traceevent: Implement libtraceevent man pages
  tools/lib/traceevent: Implement libtraceevent man pages
  tools/lib/traceevent: Implement libtraceevent man pages
  tools/lib/traceevent: Implement libtraceevent man pages
  tools/lib/traceevent: Implement libtraceevent man pages
  tools/lib/traceevent: Implement libtraceevent man pages

 .../Documentation/libtraceevent-cpus.txt      | 78 +++++++++++++++
 .../libtraceevent-file_endian.txt             | 87 ++++++++++++++++
 .../libtraceevent-header_size.txt             | 73 ++++++++++++++
 .../libtraceevent-host_endian.txt             | 85 ++++++++++++++++
 .../libtraceevent-latency_format.txt          | 98 +++++++++++++++++++
 .../Documentation/libtraceevent-page_size.txt | 79 +++++++++++++++
 .../Documentation/libtraceevent-strerror.txt  | 82 ++++++++++++++++
 tools/lib/traceevent/event-parse-api.c        |  4 +-
 8 files changed, 584 insertions(+), 2 deletions(-)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.t=
xt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_e=
ndian.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header=
_size.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_e=
ndian.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latenc=
y_format.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_s=
ize.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerr=
or.txt

--=20
2.17.2
