Return-Path: <SRS0=MeYK=SF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F49DC4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E33C22147C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 13:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfDCNAF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 09:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfDCNAF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 09:00:05 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88CAA2084B;
        Wed,  3 Apr 2019 13:00:04 +0000 (UTC)
Date:   Wed, 3 Apr 2019 09:00:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v9 01/11] trace-cmd: Make ports unsigned int
Message-ID: <20190403090002.75119b51@gandalf.local.home>
In-Reply-To: <20190402134540.32321-2-kaslevs@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
        <20190402134540.32321-2-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  2 Apr 2019 16:45:30 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> -static int write_ints(char *buf, size_t buf_len, int *arr, int arr_len)
> +static unsigned int atou(const char *s)
> +{
> +	long r;
> +
> +	r = atol(s);
> +	if (r >= 0 && r <= UINT_MAX)
> +		return r;
> +
> +	return 0;
> +}
> +

I wonder if we should do this instead:

/* test a to u */
static int tatou(const char *s, int *res)
{
	long r;

	r = atol(s);
	if (r >= 0 && r <= UINT_MAX) {
		*res = (unsigned)r;
		return 0;
	}
	return -1;
}

That way we could check for invalid ints.

-- Steve
