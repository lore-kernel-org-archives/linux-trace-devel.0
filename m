Return-Path: <SRS0=aEXj=QI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765A1C282D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 11:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B4D21904
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 11:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfBALV3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Feb 2019 06:21:29 -0500
Received: from s30320.gliwa.com ([148.251.52.238]:34590 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbfBALV2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Feb 2019 06:21:28 -0500
Received: by mail.gliwa.com (Postfix, from userid 992)
        id AB684340085; Fri,  1 Feb 2019 12:21:24 +0100 (CET)
X-Virus-Checker-Version: ClamAV 0.100.2/25346/Thu Jan 31 20:27:33 2019
X-Virus-Status: OK
Received: from [192.168.2.102] (dslb-178-003-217-062.178.003.pools.vodafone-ip.de [178.3.217.62])
        by mail.gliwa.com (Postfix) with ESMTPSA id 7D9C2340080;
        Fri,  1 Feb 2019 12:21:24 +0100 (CET)
Subject: Re: [PATCH v3 00/46] Libtraceevent MAN pages
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
From:   Claudio <claudio.fontana@gliwa.com>
Message-ID: <16b1adc6-39bf-d020-c0ed-65ccd7fdd899@gliwa.com>
Date:   Fri, 1 Feb 2019 12:21:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello all,

I was just thinking that there be some additional information about potential use for RT applications.

In particular I am interested about its potential use for AUTOSAR AP (Adaptive Platform).

https://www.autosar.org/standards/adaptive-platform/

The first things that come to mind is to mark the functions which have unbound latency costs,
allocate memory, etc, so they can be relegated to the Initialization Phase,
so that in the RT Run Phase (kRunning) these can be avoided.

Another big theme I think is a good description of potential use in multithreaded applications,
and which are the potential pitfalls there..

Ciao,

Claudio

On 11/27/18 4:42 PM, Tzvetomir Stoyanov wrote:
> This patch series includes implementation of libtraceevent
> man pages, describing all APIs of the library.
> V3 combines all man page related pathes into one series. It
> also removes any dependencies between man page related patches
> and pathes related to the APIs implementation.
> 
> Tzvetomir Stoyanov (46):
>   tools/lib/traceevent: Implement libtraceevent man pages
>   tools/lib/traceevent: Fix libtraceevent/Documentation Makefile
>   tools/lib/traceevent: Add support for man pages with multiple names
>   tools/lib/traceevent: libtraceevent Makefile "help" target
>   tools/lib/traceevent: libtraceevent man pages for tep_handler related
>     APIs
>   tools/lib/traceevent: Man page for tep_get_header_page_size()
>   tools/lib/traceevent: Man page for tep_get_cpus() and tep_set_cpus()
>   tools/lib/traceevent: Man page for tep_is_file_bigendian() and
>     tep_set_file_bigendian()
>   tools/lib/traceevent: Man page for tep_is_host_bigendian() and
>     tep_set_host_bigendian()
>   tools/lib/traceevent: Man page for tep_is_latency_format() and
>     tep_set_latency_format()
>   tools/lib/traceevent: Man page for tep_get_page_size() and
>     tep_set_page_size()
>   tools/lib/traceevent: Man page for tep_strerror()
>   tools/lib/traceevent: Man page for tep_register_trace_clock()
>   tools/lib/traceevent: Man pages for tep_register_event_handler() and
>     tep_unregister_event_handler()
>   tools/lib/traceevent: Man pages for tep_register_function() and
>     tep_register_print_string()
>   tools/lib/traceevent: Man pages for tep_register_print_function() and
>     tep_unregister_print_function()
>   tools/lib/traceevent: Man page for tep_read_number()
>   tools/lib/traceevent: Man pages for tep_find_event(),
>     tep_find_event_by_name() and tep_find_event_by_record()
>   tools/lib/traceevent: Man page for tep_list_events()
>   tools/lib/traceevent: Man pages for tep_print_event(),
>     tep_print_event_data(), tep_event_info(), tep_print_event_task() and
>     tep_print_event_time()
>   tools/lib/traceevent: Man pages tep_get_first_event() and
>     tep_get_events_count()
>   tools/lib/traceevent: Man pages tep_find_common_field(),
>     tep_find_field() and tep_find_any_field()
>   tools/lib/traceevent: Man pages tep_get_any_field_val(),
>     tep_get_common_field_val(), tep_get_field_val() and
>     tep_get_field_raw()
>   tools/lib/traceevent: Man pages for tep_print_field(),
>     tep_print_fields(), tep_print_num_field() and tep_print_func_field()
>   tools/lib/traceevent: Man page for tep_read_number_field()
>   tools/lib/traceevent: Man pages for tep_event_common_fields() and
>     tep_event_fields()
>   tools/lib/traceevent: Man pages for tep_filter_alloc(),
>     tep_filter_free() and tep_filter_reset()
>   tools/lib/traceevent: Man page for tep_filter_add_filter_str()
>   tools/lib/traceevent: Man page for tep_filter_strerror()
>   tools/lib/traceevent: Man pages for tep_event_filtered() and
>     tep_filter_remove_event()
>   tools/lib/traceevent: Man page for tep_filter_match()
>   tools/lib/traceevent: Man pages for tep_filter_copy() and
>     tep_filter_compare()
>   tools/lib/traceevent: Man page for tep_filter_make_string()
>   tools/lib/traceevent: Man pages for tep_filter_event_has_trivial(),
>     tep_update_trivial() and tep_filter_clear_trivial()
>   tools/lib/traceevent: Man pages for tep_find_function() and
>     tep_find_function_address()
>   tools/lib/traceevent: Man pages for tep_set_function_resolver() and
>     tep_reset_function_resolver()
>   tools/lib/traceevent: Man pages for tep_parse_event() and
>     tep_parse_format()
>   tools/lib/traceevent: Man page for tep_parse_header_page()
>   tools/lib/traceevent: Man pages for tep_load_plugins() and
>     tep_unload_plugin()
>   tools/lib/traceevent: Man page for tep_data_lat_fmt()
>   tools/lib/traceevent: Man pages for tep_data_type(), tep_data_pid(),
>     tep_data_preempt_count() and tep_data_flags()
>   tools/lib/traceevent: Man pages for trace_seq_init() and
>     trace_seq_destroy()
>   tools/lib/traceevent: Man pages for trace_seq_do_fprintf() and
>     trace_seq_do_printf()
>   tools/lib/traceevent: Man pages for trace_seq_printf() and
>     trace_seq_vprintf()
>   tools/lib/traceevent: Man pages for trace_seq_putc() and
>     trace_seq_puts()
>   tools/lib/traceevent: Man pages for trace_seq_reset() and
>     trace_seq_terminate()
> 
>  tools/lib/traceevent/Documentation/Makefile   | 208 ++++++++++++++++++
>  .../traceevent/Documentation/asciidoc.conf    | 120 ++++++++++
>  .../Documentation/libtraceevent-commands.txt  | 130 +++++++++++
>  .../Documentation/libtraceevent-cpus.txt      |  78 +++++++
>  .../libtraceevent-endian_read.txt             |  76 +++++++
>  .../libtraceevent-event_find.txt              |  99 +++++++++
>  .../libtraceevent-event_list.txt              |  94 ++++++++
>  .../libtraceevent-event_print.txt             | 126 +++++++++++
>  .../Documentation/libtraceevent-events.txt    |  87 ++++++++
>  .../libtraceevent-field_find.txt              |  98 +++++++++
>  .../libtraceevent-field_get_val.txt           | 117 ++++++++++
>  .../libtraceevent-field_print.txt             | 120 ++++++++++
>  .../libtraceevent-field_read.txt              |  80 +++++++
>  .../Documentation/libtraceevent-fields.txt    |  99 +++++++++
>  .../libtraceevent-file_endian.txt             |  89 ++++++++
>  .../Documentation/libtraceevent-filter.txt    |  85 +++++++
>  .../libtraceevent-filter_add.txt              |  78 +++++++
>  .../libtraceevent-filter_error.txt            |  78 +++++++
>  .../libtraceevent-filter_event.txt            |  84 +++++++
>  .../libtraceevent-filter_match.txt            |  96 ++++++++
>  .../libtraceevent-filter_oper.txt             |  84 +++++++
>  .../libtraceevent-filter_show.txt             |  75 +++++++
>  .../libtraceevent-filter_trivial.txt          | 112 ++++++++++
>  .../Documentation/libtraceevent-func_find.txt |  88 ++++++++
>  .../libtraceevent-func_resolve.txt            |  96 ++++++++
>  .../Documentation/libtraceevent-handle.txt    | 101 +++++++++
>  .../libtraceevent-header_size.txt             |  73 ++++++
>  .../libtraceevent-host_endian.txt             |  90 ++++++++
>  .../libtraceevent-latency_format.txt          | 100 +++++++++
>  .../Documentation/libtraceevent-long_size.txt |  78 +++++++
>  .../Documentation/libtraceevent-page_size.txt |  80 +++++++
>  .../libtraceevent-parse_event.txt             |  90 ++++++++
>  .../libtraceevent-parse_head.txt              |  82 +++++++
>  .../Documentation/libtraceevent-plugins.txt   |  98 +++++++++
>  .../libtraceevent-record_lat.txt              |  77 +++++++
>  .../libtraceevent-record_parse.txt            | 134 +++++++++++
>  .../Documentation/libtraceevent-reg_clock.txt |  77 +++++++
>  .../libtraceevent-reg_event_handler.txt       | 129 +++++++++++
>  .../libtraceevent-reg_funcstr.txt             |  89 ++++++++
>  .../libtraceevent-reg_print_func.txt          | 128 +++++++++++
>  .../Documentation/libtraceevent-set_flag.txt  |  90 ++++++++
>  .../Documentation/libtraceevent-strerror.txt  |  78 +++++++
>  .../Documentation/libtraceevent-tseq.txt      |  76 +++++++
>  .../libtraceevent-tseq_doprint.txt            |  89 ++++++++
>  .../libtraceevent-tseq_print.txt              |  96 ++++++++
>  .../Documentation/libtraceevent-tseq_put.txt  |  89 ++++++++
>  .../libtraceevent-tseq_reset.txt              |  78 +++++++
>  .../Documentation/libtraceevent.txt           | 198 +++++++++++++++++
>  .../traceevent/Documentation/manpage-1.72.xsl |  14 ++
>  .../traceevent/Documentation/manpage-base.xsl |  35 +++
>  .../Documentation/manpage-bold-literal.xsl    |  17 ++
>  .../Documentation/manpage-normal.xsl          |  13 ++
>  .../Documentation/manpage-suppress-sp.xsl     |  21 ++
>  tools/lib/traceevent/Makefile                 |  28 +++
>  54 files changed, 4845 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/Makefile
>  create mode 100644 tools/lib/traceevent/Documentation/asciidoc.conf
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-commands.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-events.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-fields.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_add.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_error.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_event.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_match.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_oper.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_show.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_trivial.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_find.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_resolve.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header_size.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record_lat.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_doprint.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_put.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_reset.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent.txt
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-1.72.xsl
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-base.xsl
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-bold-literal.xsl
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-normal.xsl
>  create mode 100644 tools/lib/traceevent/Documentation/manpage-suppress-sp.xsl
> 

-- 
B.Sc.CS Claudio Fontana
Senior Software Developer

GLIWA GmbH embedded systems
Pollinger Str. 1
D - 82362 Weilheim i.OB.

tel: +49-881-13 85 22-45
fax: +49-881-13 85 22-99

email: claudio.fontana@gliwa.com
web:   www.gliwa.com

Geschäftsführer (CEO) Peter Gliwa

Amtsgericht München | HRB 167925
Steuernummer 119 / 127 / 50436
USt. IdNr. DE814169157
D.U.N.S. 551053924
