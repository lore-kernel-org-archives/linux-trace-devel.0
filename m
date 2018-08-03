Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42011 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731083AbeHCP6N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 11:58:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id e7-v6so5506978wrs.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Aug 2018 07:01:43 -0700 (PDT)
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization model
 used by the Qt-based KS
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
 <20180731135248.30587-4-y.karadz@gmail.com>
 <20180801144413.227e0dea@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f89ed00a-2411-7540-bfea-8c40a6d3dcac@gmail.com>
Date: Fri, 3 Aug 2018 17:01:45 +0300
MIME-Version: 1.0
In-Reply-To: <20180801144413.227e0dea@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  1.08.2018 21:44, Steven Rostedt wrote:
>> +
>> +/**
>> + * @brief In a given bin, start from the front end of the bin and go towards
>> + *	  the back end, searching for an entry satisfying the Matching
>> + *	  condition defined by a Matching condition function.
>> + * @param histo: Input location for the model descriptor.
>> + * @param bin: Bin id.
>> + * @param vis_only: If true, a visible entry is requested.
>> + * @param func: Matching condition function.
>> + * @param val: Matching condition value, used by the Matching condition
>> + *	       function.
>> + * @param index: Optional output location for the index of the requested
>> + *		 entry inside the array.
>> + * @returns Pointer ot a kshark_entry, if an entry has been found. Else NULL.
>> + */
>> +const struct kshark_entry *
>> +ksmodel_get_entry_front(struct kshark_trace_histo *histo,
>> +			int bin, bool vis_only,
>> +			matching_condition_func func, int val,
>> +			ssize_t *index)
>> +{
>> +	struct kshark_entry_request *req;
>> +	const struct kshark_entry *entry;
>> +
>> +	if (index)
>> +		*index = KS_EMPTY_BIN;
>> +
>> +	/* Set the position at the beginning of the bin and go forward. */
>> +	req = ksmodel_entry_front_request_alloc(histo, bin, vis_only,
>> +							    func, val);
>> +	if (!req)
>> +		return NULL;
>> +
>> +	entry = kshark_get_entry_front(req, histo->data, index);
>> +	free(req);
>> +
>> +	return entry;
>> +}
> We could save on the allocation if we were to create the following:
> 
> void
> kshark_entry_request_set(struct kshark_entry_request *req,
> 			 size_t first, size_t n,
> 			 matching_condition_func cond, int val,
> 			 bool vis_only, int vis_mask)
> {
> 	req->first = first;
> 	req->n = n;
> 	req->cond = cond;
> 	req->val = val;
> 	req->vis_only = vis_only;
> 	req->vis_mask = vis_mask;
> }
> 
> bool
> ksmodel_entry_front_request_set(struct kshark_trace_histo *histo,
> 				struct kshark_entry_request *req,
> 				int bin, bool vis_only,
> 				matching_condition_func func, int val)
> {
> 	size_t first, n;
> 
> 	/* Get the number of entries in this bin. */
> 	n = ksmodel_bin_count(histo, bin);
> 	if (!n)
> 		return false;
> 
> 	first = ksmodel_first_index_at_bin(histo, bin);
> 
> 	kshark_entry_request_set(first, n,
> 			       func, val,
> 			       vis_only, KS_GRAPH_VIEW_FILTER_MASK);
> 
> 	return true;
> }
> 
> const struct kshark_entry *
> ksmodel_get_entry_front(struct kshark_trace_histo *histo,
> 			int bin, bool vis_only,
> 			matching_condition_func func, int val,
> 			ssize_t *index)
> {
> 	struct kshark_entry_request req;
> 	const struct kshark_entry *entry;
> 	bool ret;
> 
> 	if (index)
> 		*index = KS_EMPTY_BIN;
> 
> 	/* Set the position at the beginning of the bin and go forward. */
> 	ret = ksmodel_entry_front_request_set(histo, bin, vis_only,
> 							    func, val);
> 	if (!ret)
> 		return NULL;
> 
> 	entry = kshark_get_entry_front(req, histo->data, index);
> 
> 	return entry;
> }
> 

Hi Steven,
I have tried implementing this, but it becomes a bit ugly in the 
following patches where the single request is transformed into a linked 
list of requests.

Thanks!
Yordan
