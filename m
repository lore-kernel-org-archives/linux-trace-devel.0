Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7BCC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82F662146F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbfC0Olw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbfC0Olw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 10:41:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E3E72087C;
        Wed, 27 Mar 2019 14:41:51 +0000 (UTC)
Date:   Wed, 27 Mar 2019 10:41:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] tools/perf,tools/lib/traceevent: Make traceevent
 APIs more consistent
Message-ID: <20190327104149.17319833@gandalf.local.home>
In-Reply-To: <20190327141946.4353-2-tstoyanov@vmware.com>
References: <20190327141946.4353-1-tstoyanov@vmware.com>
        <20190327141946.4353-2-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 27 Mar 2019 16:19:42 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> /**
> - * tep_file_bigendian - get if the file is in big endian order
> + * tep_is_file_bigendian - return the endian of the file
>   * @pevent: a handle to the tep_handle
>   *
> - * This returns if the file is in big endian order
> - * If @pevent is NULL, 0 is returned.
> + * This returns true if the file is in big endian order
> + * If @pevent is NULL, false is returned.
>   */
> -int tep_file_bigendian(struct tep_handle *pevent)
> +bool tep_is_file_bigendian(struct tep_handle *pevent)
>  {
>  	if (pevent)
> -		return pevent->file_bigendian;
> -	return 0;
> +		return (pevent->file_bigendian == TEP_BIG_ENDIAN);

One thing I should have mentioned before, is that, when people write
returns like this to the Linux kernel mailing list, you might get a
comment like: "return is not a function, lose the parenthesis". 

That is, it should be:

	return pevent->file_bigendian == TEP_BIG_ENDIAN;

not

	return (pevent->file_bigendian == TEP_BIG_ENDIAN);

If this is the only issue, I may just fix it myself. Just remember that
returns should never have an outside parenthesis.

-- Steve


> +	return false;
>  }
>  
