Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7D2C27C53
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 23:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347122AbjHPXW2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 19:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347148AbjHPXWO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 19:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29511FD0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 16:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D89C6195A
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 23:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671E8C433C8;
        Wed, 16 Aug 2023 23:22:12 +0000 (UTC)
Date:   Wed, 16 Aug 2023 19:22:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 15/17] libtraceeval histogram: Add
 traceeval_iterator_sort_custom()
Message-ID: <20230816192216.6cebc109@gandalf.local.home>
In-Reply-To: <20230816225716.GC3686281@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-16-rostedt@goodmis.org>
        <20230816225716.GC3686281@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Aug 2023 16:57:16 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > +static int iter_custom_cmp(const void *A, const void *B, void *data)
> > +{
> > +	struct iter_custom_data *cust_data = data;
> > +	struct traceeval_iterator *iter = cust_data->iter;
> > +	struct traceeval *teval = iter->teval;
> > +	const struct entry *a = *((const struct entry **)A);
> > +	const struct entry *b = *((const struct entry **)B);
> > +
> > +	return cust_data->sort_fn(teval, a->keys, a->vals, b->keys, b->vals,
> > +				  cust_data->data);
> > +}
> > +
> > +int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
> > +				   traceeval_cmp_fn sort_fn, void *data)
> > +{
> > +	struct iter_custom_data cust_data = {
> > +		.iter = iter,
> > +		.sort_fn = sort_fn,
> > +		.data = data
> > +	};
> > +
> > +	qsort_r(iter->entries, iter->nr_entries, sizeof(*iter->entries),
> > +		iter_custom_cmp, &cust_data);  
> 
> I guess I don't yet see what this gives us over the existing sorting and
> iterators?  Does this do the same thing, we just pass in the sort function
> instead of calling traceeval_iterator_sort() one or more times?

This should be used in replace of the other sorting. It allows the user to
make a complex sort. If you look at the last patch, the sample uses this:

+/*
+ * Sort all the processes by the RUNNING state.
+ *  If A and B have the same COMM, then sort by state.
+ *  else
+ *    Find the RUNNNIG state for A and B
+ *    If the RUNNING state does not exist, it's considered -1
+ *  If RUNNING is equal, then sort by COMM.
+ */
+static int compare_pdata(struct traceeval *teval_data,
+				const union traceeval_data *Akeys,
+				const union traceeval_data *Avals,
+				const union traceeval_data *Bkeys,
+				const union traceeval_data *Bvals,
+				void *data)
+{
+	struct traceeval *teval = data; /* The deltas are here */
+	union traceeval_data keysA[] = {
+		{ .cstring = Akeys[0].cstring }, { .number = RUNNING } };
+	union traceeval_data keysB[] = {
+		{ .cstring = Bkeys[0].cstring }, { .number = RUNNING } };
+	struct traceeval_stat *statA;
+	struct traceeval_stat *statB;
+	unsigned long long totalA = -1;
+	unsigned long long totalB = -1;
+
+	/* First check if we are on the same task */
+	if (strcmp(Akeys[0].cstring, Bkeys[0].cstring) == 0) {
+		/* Sort decending */
+		if (Bkeys[1].number > Akeys[1].number)
+			return -1;
+		return Bkeys[1].number != Akeys[1].number;
+	}
+
+	/* Get the RUNNING values for both processes */
+	statA = traceeval_stat(teval, keysA, &delta_vals[0]);
+	if (statA)
+		totalA = traceeval_stat_total(statA);
+
+	statB = traceeval_stat(teval, keysB, &delta_vals[0]);
+	if (statB)
+		totalB = traceeval_stat_total(statB);
+
+	if (totalB < totalA)
+		return -1;
+	if (totalB > totalA)
+		return 1;
+
+	return strcmp(Bkeys[0].cstring, Akeys[0].cstring);
+}


> 
> > +
> > +	iter->needs_sort = false;  
> 
> Also probably need to set
>   iter->next = 0;

So much for redundancy!

Thanks,

-- Steve

> 
> > +	return 0;
> > +}
> > +
