Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71785C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 403B22084B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfCZNfL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbfCZNfK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 09:35:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144F42075D;
        Tue, 26 Mar 2019 13:35:10 +0000 (UTC)
Date:   Tue, 26 Mar 2019 09:35:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] tools/lib/traceevent: Implement new traceevent
 APIs for accessing struct tep_handler fields
Message-ID: <20190326093508.5957a54a@gandalf.local.home>
In-Reply-To: <20190325145017.30246-4-tstoyanov@vmware.com>
References: <20190325145017.30246-1-tstoyanov@vmware.com>
        <20190325145017.30246-4-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Mar 2019 16:50:17 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +
> +/**
> + * tep_is_old_format - get if an old kernel is used
> + * @tep: a handle to the tep_handle
> + *
> + * This returns true, if an old kernel is used to generate the tracing events or
> + * false if a new kernel is used. Old kernels did not have header page info.
> + * If @pevent is NULL, false is returned.

I renamed this to @tep.



>  static inline int tep_host_bigendian(void)
>  {
> @@ -565,6 +567,10 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
>  int tep_is_latency_format(struct tep_handle *pevent);
>  void tep_set_latency_format(struct tep_handle *pevent, int lat);
>  int tep_get_header_page_size(struct tep_handle *pevent);
> +int tep_get_header_timestamp_size(struct tep_handle *tep);
> +bool tep_is_old_format(struct tep_handle *pevent);

And this to *tep);

-- Steve

> +void tep_set_print_raw(struct tep_handle *tep, int print_raw);
> +void tep_set_test_filters(struct tep_handle *tep, int test_filters);
>  
>  struct tep_handle *tep_alloc(void);
>  void tep_free(struct tep_handle *pevent);

