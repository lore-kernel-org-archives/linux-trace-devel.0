Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C78CC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 403FD2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfCHOTF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:19:05 -0500
Received: from s30320.gliwa.com ([148.251.52.238]:34718 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726431AbfCHOTE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:19:04 -0500
Received: by mail.gliwa.com (Postfix, from userid 992)
        id 67A2D340E21; Fri,  8 Mar 2019 15:19:01 +0100 (CET)
X-Virus-Checker-Version: ClamAV 0.101.1/25382/Fri Mar 8 09:55:42 2019
X-Virus-Status: OK
Received: from [192.168.2.102] (dslb-178-003-217-045.178.003.pools.vodafone-ip.de [178.3.217.45])
        by mail.gliwa.com (Postfix) with ESMTPSA id 2F542340E0F;
        Fri,  8 Mar 2019 15:19:01 +0100 (CET)
Subject: Re: [PATCH v4 00/46] Libtraceevent MAN pages
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20190308133654.21264-1-tstoyanov@vmware.com>
From:   Claudio <claudio.fontana@gliwa.com>
Message-ID: <438810f6-6a04-aa9d-a38a-1d0e04c03c5c@gliwa.com>
Date:   Fri, 8 Mar 2019 15:19:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 3/8/19 2:36 PM, Tzvetomir Stoyanov wrote:
> [
>  V4 changes:
>   - Addressed Steven Rostedt comments
>   - Removed trailing whitespace
> 
>  V3 changes:
>   - Combines all man page related patches into one series. 
>   - Removes any dependencies between man page related patches
>     and patches related to the APIs implementation.
> ]
> 
> This patch series includes implementation of libtraceevent
> man pages, describing all APIs of the library.

Hello,

is there a general man page entry that explains what libtracevent does?

Maybe a manual section 3 or 7 entry like 

LIBTRACEEVENT(3)

Maybe I have missed it? I think it would helpful, to avoid a disconnect between what a user might expect the library to do,
vs what it actually does, to which use case it is suited for.

Just as a case in point, at the moment these are the features which would be needed for me to use this
library for the real time tracing requirements I am facing (response times, fixed allocation of cpu tracing usage/overhead):

- resource usage description of APIs, which APIs allocate memory, open file descriptors and such,
  some examples of resource lifetime would be helpful (pardon if they are there already and I missed them)

- support for in-order delivery of events already correlated from multiple cores

- network streaming support (maybe already working?)

- support for getting TGID in addition to the COMM for each (sched) event in addition to the PID.

Currently we have implemented all of this inside the application,
but we could get rid of this complexity in the future if this library could provide this out of the box,
without serious impacts on cpu overhead and latency requirements.

Just a simple description of the overall goals of the library and common patterns,
notes on resource usage, etc, would be enough I think to be able to quickly see if it fits the application use case..

Thank you,

Claudio

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
>  .../Documentation/libtraceevent-cpus.txt      |  77 +++++++
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
>  .../libtraceevent-host_endian.txt             |  91 ++++++++
>  .../libtraceevent-latency_format.txt          | 140 ++++++++++++
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
>  54 files changed, 4885 insertions(+)
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

