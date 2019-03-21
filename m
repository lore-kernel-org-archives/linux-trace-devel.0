Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E1EC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 19:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24B42218FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 19:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfCUTqG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbfCUTqG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 15:46:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 189CE218D4;
        Thu, 21 Mar 2019 19:46:05 +0000 (UTC)
Date:   Thu, 21 Mar 2019 15:46:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Matt Helsley <mhelsley@vmware.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Message-ID: <20190321154602.5c49bd38@gandalf.local.home>
In-Reply-To: <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
        <20190319111924.17443-4-tstoyanov@vmware.com>
        <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 20 Mar 2019 16:32:25 +0000
Matt Helsley <mhelsley@vmware.com> wrote:

> > 				    unsigned long long *addrp, char **modp);
> > -void tep_set_flag(struct tep_handle *tep, int flag);
> > +void tep_set_flag(struct tep_handle *tep, enum tep_flag flag);
> > +void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag);
> > +int tep_check_flag(struct tep_handle *tep, enum tep_flag flag);
> > 
> > static inline int tep_host_bigendian(void)
> > {  
> 
> Does another series rename this to: tep_is_host_bigendian() ?

I've been looking at the API and I think we do need to make it more
consistent. What we currently have is:


> void tep_set_flag(struct tep_handle *tep, enum tep_flag flag);
> void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag);

(I'll ignore parameters)

Rename to: void tep_clear_flag()

> int tep_check_flag(struct tep_handle *tep, enum tep_flag flag);

Rename to: bool tep_test_flag()


> 
> int tep_host_bigendian(void);

Rename to: bool tep_is_bigendian()

(Break from the confusion to what a "host" is)

> 
> int tep_set_function_resolver(struct tep_handle *pevent,
> 			      tep_func_resolver_t *func, void *priv);
> void tep_reset_function_resolver(struct tep_handle *pevent);
> int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
> int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid);
> int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
> int tep_register_function(struct tep_handle *pevent, char *name,
> 			  unsigned long long addr, char *mod);
> int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
> 			      unsigned long long addr);
> int tep_pid_is_registered(struct tep_handle *pevent, int pid);

Rename to: bool tep_is_pid_registered()


> 
> int tep_get_cpus(struct tep_handle *pevent);
> void tep_set_cpus(struct tep_handle *pevent, int cpus);
> int tep_get_long_size(struct tep_handle *pevent);
> void tep_set_long_size(struct tep_handle *pevent, int long_size);
> int tep_get_page_size(struct tep_handle *pevent);
> void tep_set_page_size(struct tep_handle *pevent, int _page_size);
> int tep_file_bigendian(struct tep_handle *pevent);

Rename to: bool tep_is_file_bigendian()

> void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian);
> int tep_is_host_bigendian(struct tep_handle *pevent);

Rename to: bool tep_is_host_bigendian()

> void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
> int tep_is_latency_format(struct tep_handle *pevent);

Rename to: bool tep_is_latency_format()

> void tep_set_latency_format(struct tep_handle *pevent, int lat);
> int tep_get_header_page_size(struct tep_handle *pevent);
> void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
> int tep_get_parsing_failures(struct tep_handle *tep);
> int tep_get_header_page_ts_size(struct tep_handle *tep);

Rename to: int tep_get_header_timestamp_size()

> int tep_is_old_format(struct tep_handle *pevent);

Rename to: bool tep_is_old_format()

These changes may need to be broken up into separate patches.

-- Steve
