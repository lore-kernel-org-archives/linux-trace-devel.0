Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0045.outbound.protection.outlook.com ([104.47.37.45]:45184
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727784AbeKIXM1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 18:12:27 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 00/10] Man pages for libtraceevent 
Date: Fri, 9 Nov 2018 13:31:46 +0000
Message-ID: <20181109133135.25804-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch series implements libtraceveent man pages,
describing APIs: tep_register_comm,tep_pid_is_registered,
tep_data_comm_from_pid,tep_data_pid_from_comm,tep_cmdline_pid,
tep_alloc,tep_free,tep_get_long_size,tep_set_long_size,
tep_set_flag,tep_get_header_page_size, tep_get_cpus, tep_set_cpus,
tep_is_file_bigendian, tep_set_file_bigendian,
tep_is_host_bigendian, tep_set_host_bigendian,
tep_is_latency_format, and tep_set_latency_format,
tep_get_page_size, tep_set_page_size and tep_strerror.
It also fixes asciidoc.conf to support man pages with multiple names,
used to combine the description of several APIs into one page.

Tzvetomir Stoyanov (11):
  tools/lib/traceevent: Fix libtraceevent/Documentation Makefile
  tools/lib/traceevent: Add support for man pages with multiple names
  tools/lib/traceevent: libtraceevent man pages for tep_handler related
    APIs
  tools/lib/traceevent: Man page for tep_get_header_page_size()
  tools/lib/traceevent: Man page for tep_get_cpus() and tep_set_cpus()
  tools/lib/traceevent: Man page for tep_is_file_bigendian() and
    tep_set_file_bigendian()
  tools/lib/traceevent: Man page for tep_is_host_bigendian() and
    tep_set_host_bigendian()
  tools/lib/traceevent: Man page for tep_is_latency_format() and
    tep_set_latency_format()
  tools/lib/traceevent: Man page for tep_get_page_size() and
    tep_set_page_size()
  tools/lib/traceevent: Man page for tep_strerror()

 tools/lib/traceevent/Documentation/Makefile   |   5 +-
 .../traceevent/Documentation/asciidoc.conf    |  35 ++++-
 .../Documentation/libtraceevent-commands.txt  | 130 ++++++++++++++++++
 .../Documentation/libtraceevent-cpus.txt      |  78 +++++++++++
 .../libtraceevent-file_endian.txt             |  89 ++++++++++++
 .../Documentation/libtraceevent-handle.txt    | 101 ++++++++++++++
 .../libtraceevent-header_size.txt             |  73 ++++++++++
 .../libtraceevent-host_endian.txt             |  90 ++++++++++++
 .../libtraceevent-latency_format.txt          | 100 ++++++++++++++
 .../Documentation/libtraceevent-long_size.txt |  79 +++++++++++
 .../Documentation/libtraceevent-page_size.txt |  80 +++++++++++
 .../Documentation/libtraceevent-set_flag.txt  |  94 +++++++++++++
 .../Documentation/libtraceevent-strerror.txt  |  78 +++++++++++
 tools/lib/traceevent/event-parse-api.c        |  31 +++--
 14 files changed, 1123 insertions(+), 103 deletions(-)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-comman=
ds.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.t=
xt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_e=
ndian.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle=
.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header=
_size.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_e=
ndian.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latenc=
y_format.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_s=
ize.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_s=
ize.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_fl=
ag.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerr=
or.txt

--=20
2.17.2
