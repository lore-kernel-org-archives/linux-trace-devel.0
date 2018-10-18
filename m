Return-Path: <SRS0=VoGV=M6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbeJRK2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Oct 2018 06:28:42 -0400
Date: Wed, 17 Oct 2018 22:30:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent: Implement libtraceevent man pages
Message-ID: <20181017223000.0046b84b@vmware.local.home>
In-Reply-To: <20181016130233.26852-1-tstoyanov@vmware.com>
References: <20181016130233.26852-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Oct 2018 13:02:47 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
> @@ -0,0 +1,199 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +libtraceevent - Linux kernel trace event library
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +Management of tep handler data structure and access of its members:
> +	struct tep_handle pass:[*]*tep_alloc*(void);
> +	void *tep_free*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_ref*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_unref*(struct tep_handle pass:[*]_pevent_);
> +	int *tep_ref_get*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_set_flag*(struct tep_handle pass:[*]_tep_, int _flag_);
> +	int *tep_get_cpus*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_set_cpus*(struct tep_handle pass:[*]_pevent_, int _cpus_);
> +	int *tep_get_long_size*(strucqt tep_handle pass:[*]_pevent_);
> +	void *tep_set_long_size*(struct tep_handle pass:[*]_pevent_, int _long_size_);
> +	int *tep_get_page_size*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_set_page_size*(struct tep_handle pass:[*]_pevent_, int _page_size_);
> +	int *tep_is_file_bigendian*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_set_file_bigendian*(struct tep_handle pass:[*]_pevent_, enum tep_endian _endian_);
> +	int *tep_is_host_bigendian*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_set_host_bigendian*(struct tep_handle pass:[*]_pevent_, enum tep_endian _endian_);
> +	int *tep_is_latency_format*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_set_latency_format*(struct tep_handle pass:[*]_pevent_, int _lat_);
> +	int *tep_get_header_page_size*(struct tep_handle pass:[*]_pevent_);


> +	int *tep_register_trace_clock*(struct tep_handle pass:[*]_pevent_, const char pass:[*]_trace_clock_);
> +	int *tep_register_function*(struct tep_handle pass:[*]_pevent_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);

These two may need a separate man page. They are different from the
others because they "register" something, which is more than just
setting a value.

> +	
> +
> +Plugins management: 
> +	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_pevent_);
> +	void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_pevent_);
> +	char pass:[*]pass:[*]*tep_plugin_list_options*(void);
> +	void *tep_plugin_free_options_list*(char pass:[*]pass:[*]_list_);
> +	int *tep_plugin_add_options*(const char pass:[*]_name_, struct tep_plugin_option pass:[*]_options_);
> +	void *tep_plugin_remove_options*(struct tep_plugin_option pass:[*]_options_);
> +	void *tep_print_plugins*(struct trace_seq pass:[*]_s_, const char pass:[*]_prefix_, const char pass:[*]_suffix_, const struct tep_plugin_list pass:[*]_list_);
> +
> +Events printing:

  "Event printing:"

> +	void *tep_print_event_task*(struct tep_handle pass:[*]_pevent_, struct trace_seq pass:[*]_s_, struct tep_event_format pass:[*]_event_, struct tep_record pass:[*]_record_);
> +	void *tep_print_event_time*(struct tep_handle pass:[*]_pevent_, struct trace_seq pass:[*]_s_, struct tep_event_format pass:[*]_event_, struct tep_record pass:[*]record, bool _use_trace_clock_);
> +	void *tep_print_event_data*(struct tep_handle pass:[*]_pevent_, struct trace_seq pass:[*]_s_, struct tep_event_format pass:[*]_event_, struct tep_record pass:[*]_record_);
> +	void *tep_print_event*(struct tep_handle pass:[*]_pevent_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
> +
> +Parsing of event files:
> +	int *tep_parse_header_page*(struct tep_handle pass:[*]_pevent_, char pass:[*]_buf_, unsigned long _size_, int _long_size_);
> +	enum *tep_errno tep_parse_event*(struct tep_handle pass:[*]_pevent_, const char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
> +	enum *tep_errno tep_parse_format*(struct tep_handle pass:[*]_pevent_, struct tep_event_format pass:[*]pass:[*]_eventp_, const char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
> +
> +Event related APIs:
> +	struct *tep_event_format pass:[*]tep_find_event*(struct tep_handle pass:[*]_pevent_, int _id_);
> +	struct *tep_event_format pass:[*]tep_find_event_by_name*(struct tep_handle pass:[*]_pevent_, const char pass:[*]_sys_, const char pass:[*]_name_);
> +	struct *tep_event_format pass:[*]tep_find_event_by_record*(struct tep_handle pass:[*]_pevent_, struct tep_record pass:[*]_record_);
> +	struct *tep_event_format pass:[*]tep_data_event_from_type*(struct tep_handle pass:[*]_pevent_, int _type_);
> +	struct *tep_event_format pass:[*]tep_get_first_event*(struct tep_handle pass:[*]_tep_);

Perhaps the above should be in their own section called "Finding
events" ?


> +	int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);

> +	void *tep_free_format*(struct tep_event_format pass:[*]_event_);

As we talked about, we need to rename that to tep_free_event(), and not
to mention renaming tep_event_format to just tep_event.

> +	struct tep_event_format pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass:[*]_pevent_, enum tep_event_sort_type _sort_type_);
> +	void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event_format pass:[*]_event_, struct tep_record pass:[*]_record_);


> +	int *tep_register_event_handler*(struct tep_handle pass:[*]_pevent_, int _id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event_handler_func _func_, void pass:[*]_context_);
> +	int *tep_unregister_event_handler*(struct tep_handle pass:[*]pevent, int id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handler_func func, void pass:[*]_context_);
> +	int *tep_register_print_string*(struct tep_handle pass:[*]_pevent_, const char pass:[*]_fmt_, unsigned long long _addr_);
> +	int *tep_register_print_function*(struct tep_handle pass:[*]_pevent_, tep_func_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name_, _..._);
> +	int *tep_unregister_print_function*(struct tep_handle pass:[*]_pevent_, tep_func_handler _func_, char pass:[*]_name_);

The registering functions should probably have their own section as
well.

> +
> +APIs related to fields from event's format files:
> +	struct tep_format_field pass:[*]*tep_find_common_field*(struct tep_event_format pass:[*]_event_, const char pass:[*]_name_);
> +	struct tep_format_field pass:[*]*tep_find_field*(struct tep_event_ormat pass:[*]_event_, const char pass:[*]_name_);
> +	struct tep_format_field pass:[*]*tep_find_any_field*(struct tep_event_format pass:[*]_event_, const char pass:[*]_name_);

Perhaps the above should be in their own page about "finding event
fields"?

> +	void *tep_free_format_field*(struct tep_format_field pass:[*]_field_);
> +	struct tep_format_field pass:[*]pass:[*]*tep_event_common_fields*(struct tep_event_format pass:[*]_event_);
> +	struct tep_format_field pass:[*]pass:[*]*tep_event_fields*(struct tep_event_format pass:[*]_event_);
> +	void pass:[*]*tep_get_field_raw*(struct trace_seq pass:[*]_s_, struct tep_event_format pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int pass:[*]_len_, int _err_);
> +	int *tep_get_field_val*(struct trace_seq pass:[*]_s_, struct tep_event_format pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
> +	int *tep_get_common_field_val*(struct trace_seq pass:[*]_s_, struct tep_event_format pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
> +	int *tep_get_any_field_val*(struct trace_seq pass:[*]_s_, struct tep_event_format pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);	
> +	void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, struct tep_format_field pass:[*]_field_);
> +	void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event_format pass:[*]_event_);
> +	int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event_format pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
> +	int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event_format pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
> +	int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, const void pass:[*]_data_, unsigned long long pass:[*]_value_);
> +	
> +
> +Functions resolver:
> +	int *tep_set_function_resolver*(struct tep_handle pass:[*]_pevent_, tep_func_resolver_t pass:[*]_func_, void pass:[*]_priv_);
> +	void *tep_reset_function_resolver*(struct tep_handle pass:[*]_pevent_);
> +	const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_pevent_, unsigned long long _addr_);
> +	unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_pevent_, unsigned long long _addr_);
> +
> +Filter management:
> +	struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass:[*]_pevent_);
> +	enum tep_errno *tep_filter_add_filter_str*(struct tep_event_filter pass:[*]_filter_, const char pass:[*]_filter_str_);
> +	enum tep_errno *tep_filter_match*(struct tep_event_filter pass:[*]_filter_, struct tep_record pass:[*]_record_);
> +	int *tep_filter_strerror*(struct tep_event_filter pass:[*]_filter_, enum tep_errno _err_, char pass:[*]buf, size_t _buflen_);
> +	int *tep_event_filtered*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
> +	void *tep_filter_reset*(struct tep_event_filter pass:[*]_filter_);
> +	int *tep_filter_clear_trivial*(struct tep_event_filter pass:[*]_filter_, enum tep_filter_trivial_type _type_);
> +	void *tep_filter_free*(struct tep_event_filter pass:[*]_filter_);
> +	char pass:[*]*tep_filter_make_string*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
> +	int *tep_filter_remove_event*(struct tep_event_filter pass:[*]filter, int _event_id_);
> +	int *tep_filter_event_has_trivial*(struct tep_event_filter pass:[*]_filter_, int _event_id_, enum tep_filter_trivial_type _type_);
> +	int *tep_filter_copy*(struct tep_event_filter pass:[*]_dest_, struct tep_event_filter pass:[*]_source_);
> +	int *tep_update_trivial*(struct tep_event_filter pass:[*]_dest_, struct tep_event_filter pass:[*]_source_, enum tep_filter_trivial_type _type_);
> +	int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struct tep_event_filter pass:[*]_filter2_);
> +
> +Parsing various data from the records:
> +	void *tep_data_lat_fmt*(struct tep_handle pass:[*]_pevent_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_);
> +	int *tep_data_type*(struct tep_handle pass:[*]_pevent_, struct tep_record pass:[*]_rec_);
> +	int *tep_data_pid*(struct tep_handle pass:[*]_pevent_, struct tep_record pass:[*]_rec_);
> +	int *tep_data_preempt_count*(struct tep_handle pass:[*]_pevent_, struct tep_record pass:[*]_rec_);
> +	int *tep_data_flags*(struct tep_handle pass:[*]_pevent_, struct tep_record pass:[*]_rec_);
> +	const char pass:[*]*tep_data_comm_from_pid*(struct tep_handle pass:[*]_pevent_, int _pid_);
> +	struct cmdline pass:[*]*tep_data_pid_from_comm*(struct tep_handle pass:[*]_pevent_, const char pass:[*]_comm_, struct cmdline pass:[*]_next_);
> +	
> +Command lines related APIs:

Although we use the term "command line" it's really task names.

 "Command / Task name related APIs:" ?

> +	int *tep_register_comm*(struct tep_handle pass:[*]_pevent_, const char pass:[*]_comm_, int _pid_);
> +	int *tep_pid_is_registered*(struct tep_handle pass:[*]_pevent_, int _pid_);
> +	int *tep_cmdline_pid*(struct tep_handle pass:[*]_pevent_, struct cmdline pass:[*]_cmdline_);
> +
> +Miscellaneous APIs:
> +	unsigned short *tep_data2host2*(struct tep_handle pass:[*]_pevent_, unsigned short _data_);
> +	unsigned int *tep_data2host4*(struct tep_handle pass:[*]_pevent_, unsigned int _data_);
> +	unsigned long long *tep_data2host8*(struct tep_handle pass:[*]_pevent_, unsigned long long _data_);
> +	int *tep_host_bigendian*(void);
> +	unsigned long long *tep_read_number*(struct tep_handle pass:[*]_pevent_, const void pass:[*]_ptr_, int _size_);

The above should be under a section called "Handling Endianess:" Or
something similar.



> +	int *tep_strerror*(struct tep_handle pass:[*]_pevent_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);

Hmm, don't we have other error functions? Perhaps this can go with the
first section about the tep_handle?


> +
> +Direct access to the internal parser:
> +	void *tep_buffer_init*(const char pass:[*]_buf_, unsigned long long _size_);
> +	enum tep_event_type *tep_read_token*(char pass:[*]pass:[*]_tok_);
> +	void *tep_free_token*(char pass:[*]_token_);
> +	int *tep_peek_char*(void);
> +	const char pass:[*]*tep_get_input_buf*(void);
> +	unsigned long long *tep_get_input_buf_ptr*(void);

Hmm, the above should probably not be part of the ABI, and we should
make it private.

> +	
> +Debugging:
> +	void *tep_print_funcs*(struct tep_handle pass:[*]_pevent_);
> +	void *t ep_print_printk*(struct tep_handle pass:[*]_pevent_);

Strange space in "t ep".

These don't need man pages, they are for our own debugging ;-)


> +
> +Trace sequences:
> +*#include <trace-seq.h>*
> +	void *trace_seq_init*(struct trace_seq pass:[*]_s_);
> +	void *trace_seq_reset*(struct trace_seq pass:[*]_s_);
> +	void *trace_seq_destroy*(struct trace_seq pass:[*]_s_);
> +	int *trace_seq_printf*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, ...);
> +	int *trace_seq_vprintf*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, va_list _args_);
> +	int *trace_seq_puts*(struct trace_seq pass:[*]_s_, const char pass:[*]_str_);
> +	int *trace_seq_putc*(struct trace_seq pass:[*]_s_, unsigned char _c_);
> +	void *trace_seq_terminate*(struct trace_seq pass:[*]_s_);
> +	int *trace_seq_do_fprintf*(struct trace_seq pass:[*]_s_, FILE pass:[*]_fp_);
> +	int *trace_seq_do_printf*(struct trace_seq pass:[*]_s_);
> +--

Other than that, it looks good!

-- Steve
