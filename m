Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0BDC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA750610A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhHSTNz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230058AbhHSTNv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 15:13:51 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5148604DC;
        Thu, 19 Aug 2021 19:13:14 +0000 (UTC)
Date:   Thu, 19 Aug 2021 15:13:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 49/87] trace-cmd library: Handle the extended DONE
 option
Message-ID: <20210819151308.6dbb36e7@oasis.local.home>
In-Reply-To: <20210729050959.12263-50-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-50-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:21 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
						\
> @@ -3159,6 +3184,12 @@ static int handle_options(struct tracecmd_input *handle)
>  				break;
>  			add_section(handle, option, -1, tep_read_number(handle->pevent, buf, 8), 0);
>  			break;
> +		case TRACECMD_OPTION_DONE:
> +			if (comperss)

s/comperss/compress/

And it needs to be fixed where it was introduced.


-- Steve

> +				in_uncompress_reset(handle);
> +			ret = handle_option_done(handle, buf, size);
> +			free(buf);
> +			return ret;
>  		default:
>  			tracecmd_warning("unknown option %d", option);
>  			break;
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 87bbcf39..01c1a4f5 100644
