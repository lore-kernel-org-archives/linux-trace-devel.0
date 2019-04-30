Return-Path: <SRS0=xYfD=TA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533D7C43219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29CDF2087B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfD3Wto (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 18:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfD3Wto (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 18:49:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 429582087B;
        Tue, 30 Apr 2019 22:49:43 +0000 (UTC)
Date:   Tue, 30 Apr 2019 18:49:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 21/30] tools/lib/traceevent: Man pages for print
 field APIs
Message-ID: <20190430184941.5b923803@gandalf.local.home>
In-Reply-To: <20190412133811.15878-22-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-22-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:38:02 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +DESCRIPTION
> +-----------
> +These functions print recorded field's data, according to the field's type.
> +
> +The _tep_print_field()_ function extracts from the recorded raw _data_ value of
> +the _field_ and prints it into _s_, according to the field type.
> +
> +The _tep_print_fields()_ prints recorded values of all _event_'s fields. It
> +iterates all fileds of the _event_, and calls _tep_print_field()_ for each of
> +them.

Probably should state that tep_print_fields() prints each field name
followed by the record's field value according to the field's type.

 "field1_name=field1_value field2_name=field2_value ..."

-- Steve

> +
> +The _tep_print_num_field()_ function prints a numeric field with given format
> +string. A search is performed in the _event_ for a field with _name_. If such
> +field is found, its value is extracted from the _record_ and is printed in the
> +_s_, according to the given format string _fmt_. If the argument _err_ is
> +non-zero, and an error occures - it is printed in the _s_.
> +
> +The _tep_print_func_field()_ function prints a function field with given format
> +string.  A search is performed in the _event_ for a field with _name_. If such
> +field is found, its value is extracted from the _record_. The value is assumed
> +to be a function address, and a search is perform to find the name of this
> +function. The function name (if found) and its address are printed in the _s_,
> +according to the given format string _fmt_. If the argument _err_ is non-zero,
> +and an error occures - it is printed in _s_.
> +
