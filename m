Return-Path: <SRS0=Ttn5=65=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EA2C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 01:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA66620727
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 01:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgEOBVp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 May 2020 21:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgEOBVp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 May 2020 21:21:45 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D17AF20671;
        Fri, 15 May 2020 01:21:44 +0000 (UTC)
Date:   Thu, 14 May 2020 21:21:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v3] trace-cmd: Add support for more printk format
 specifiers
Message-ID: <20200514212143.05c102b1@oasis.local.home>
In-Reply-To: <20200514071222.2396423-1-tz.stoyanov@gmail.com>
References: <20200514071222.2396423-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 May 2020 10:12:22 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:


> +static int print_pointer(struct trace_seq *s, const char *format, int plen,
> +			 void *data, int size,
> +			 struct tep_event *event, struct tep_print_arg *arg)
> +{
> +	unsigned long long val;
> +	int ret = 1;
> +
> +	switch (*format) {
> +	case 'F':
> +	case 'f':
> +	case 'S':
> +	case 's':
> +		ret += print_function(s, format, data, size, event, arg);
> +		break;
> +	case 'M':
> +	case 'm':
> +		ret += print_mac_arg(s, format, data, size, event, arg);
> +		break;
> +	case 'I':
> +	case 'i':
> +		ret += print_ip_arg(s, format, data, size, event, arg);
> +		break;
> +	case 'U':
> +		ret += print_uuid_arg(s, format, data, size, event, arg);
> +		break;
> +	case 'h':
> +		ret += print_raw_buff_arg(s, format, data, size, event, arg, plen);
> +		break;
> +	default:
> +		ret = 0;
> +		val = eval_num_arg(data, size, event, arg);
> +		if (event->tep->long_size == 4)
> +			trace_seq_printf(s, "0x%lx", (long)val);
> +		else
> +			trace_seq_printf(s, "0x%llx", (long long)val);

Hmm, this failed my tests as it changes the output of what use to be
printed. At least for val == 0.

778c778
<            sleep-3946  [001]   111.264656: kfree:                call_site=c029dbb5 ptr=0x0
---
>            sleep-3946  [001]   111.264656: kfree:                call_site=c029dbb5 ptr=(nil)

It use to print "(nil)" but now prints 0x0. The old way for %p would
just use the '%p' format. I'd like to keep that the same for this.

-- Steve



> +		break;
> +	}
> +
> +	return ret;
> +
> +}
> +
