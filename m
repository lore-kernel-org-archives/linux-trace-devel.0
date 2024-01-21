Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF0C2A1D3
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 19:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705864149; cv=none; b=Vgskaz7brsXQhUFa+rNNDe1pPFluadzZVhGoxP0e0Q46wVBI9gVD7n77kOdYU7HBD9b5fgbdS9xL3I2uDw7quRIisw8PCLS1MPLZuup1i7AtiseA4uxUOz9mwgKRbY63gkhYKNgrD6r1qQNJE4BgtqC4Cg4mH7nTh+3ncL+gzFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705864149; c=relaxed/simple;
	bh=LrHW/iGoGDezmply1TDqma/vxDnIMGB81pRtj8WtxfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNVwdpj4R6kTi6En/WlhmSHUJAnTbL8Jbj7d4TJ1COnsVNh2hXtJ4LH1tqm+a66+TkcBa2+tNJXBYieHbj99Gr9QVJpB7nvnRIS5VxVwVDQB5pk4AZbTMZ+sMvZyWC1naO94zTKr+9HDwcNjQG4KEXHD89wTl93YJvSI9caV/Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gvEm14nZ; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvEm14nZ"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a2cea0563cbso362086466b.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 11:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705864146; x=1706468946; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x9wxPZ1JlVN181ql4zEMYQC84Mx1j6qtjXN96zhC4UA=;
        b=gvEm14nZtuqZnv4xaxR4XJ5c5kScN4Niv/+zZa4KK0WMT5VSFeyN5/2PPa4r2HcoSK
         +N2UpmyNRPdAlyqSplBhQl2pUsqRsGo5WhEIWMcnhu/PTqtkQWBcQtmrc5zm1hDgbCM2
         fpfRxYgLLFrGpXk2p4WHkzimUiW8eQNevKxs/kiEhCOqIMTVPYQFwHtmKFCKcU62zqrP
         X81Sc/QDXGx+6O2Wps++eU8lL173LfnHZp4a3QkpjQ6NBB4YFNWI42iObHJxsbNyxmDC
         eiHEkq8zL6B5sZX2WiFbGU9laKX1OV3OK4MA7nIcazAmqTuBuFCVm4zz4LFRrJxc2DOC
         bjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705864146; x=1706468946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x9wxPZ1JlVN181ql4zEMYQC84Mx1j6qtjXN96zhC4UA=;
        b=S8c4+9j8l1LaGzUAYQlFVQlxfJuVIr0FTdDU4szaan/l1hhBXBcNp/3b6goj9ymCgp
         AMHRNULPwFFEKUt3y2NbRcpB6qBN0iKM2MQuctpSpO1taVyLy5vz5jG9a+lRajXpPM4c
         UG2qp9EHTF4OFQR0s4JqRqkNVvU/kD8EaKTSU0LmlHaUssY91BsSaDs1D9ndCI6bBOIA
         lizbfna8eQUy1bqF4Py+eQjetNXmrtU64n29RqPZyA8Hxfeoy3jAo5hhcn1zurTTijXT
         dAKSzXaKZIWKIm9u3PQrm4ddWb7XIhE6ai+tB0WR76hd605ks6kRoXI/02SC7Fc+isgK
         kSuA==
X-Gm-Message-State: AOJu0Yw/wl8PUbFozjuiQjFa4m/xDNwUktxAwAIU+XbJjbazgK0jxx7B
	ErUWeZrNBngkwqyV8+i+hOechu1X5rC+knep8GLREtdYkK4oKLe6geCD/Msk
X-Google-Smtp-Source: AGHT+IFR9NciwDr0cynqI3rfiPoxcVHRkf2myVgGc+pBETiV/yopQQ7ghAiVqrsDdWQ0A9nuwC+vFg==
X-Received: by 2002:a17:907:a803:b0:a2e:d6af:a9c4 with SMTP id vo3-20020a170907a80300b00a2ed6afa9c4mr2055107ejc.0.1705864145605;
        Sun, 21 Jan 2024 11:09:05 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id qo3-20020a170907874300b00a2fb9c0337esm2064297ejc.112.2024.01.21.11.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 11:09:05 -0800 (PST)
Message-ID: <ab1645d8-9b63-94c0-648e-2350f6cd4812@gmail.com>
Date: Sun, 21 Jan 2024 21:09:04 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 31/34] kernelshark: Fix comparison of integers of
 different signs warnings
Content-Language: en-US
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-32-dev@benjarobin.fr>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240114171723.14092-32-dev@benjarobin.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/14/24 19:17, Benjamin ROBIN wrote:
> Most of them have been fixed, but a few still remain.
> 
> Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
> ---
>   examples/configio.c        |  3 ++-
>   examples/datafilter.c      |  9 ++++++---
>   examples/datahisto.c       |  2 +-
>   src/libkshark-collection.c | 14 ++++++++------
>   src/libkshark-configio.c   |  6 ++++--
>   src/libkshark-hash.c       |  5 +++--
>   src/libkshark-model.c      | 16 +++++++++-------
>   src/libkshark-tepdata.c    |  2 +-
>   src/libkshark.c            | 17 +++++++++--------
>   src/plugins/sched_events.c |  2 +-
>   10 files changed, 44 insertions(+), 32 deletions(-)
> 
> diff --git a/examples/configio.c b/examples/configio.c
> index 9710d53..575211d 100644
> --- a/examples/configio.c
> +++ b/examples/configio.c
> @@ -8,7 +8,8 @@ int main(int argc, char **argv)
>   	struct kshark_config_doc *conf, *filter, *hello;
>   	struct kshark_context *kshark_ctx;
>   	struct kshark_data_stream *stream;
> -	int sd, *ids = NULL, i;
> +	int sd, *ids = NULL;
> +	size_t i;
>   
>   	/* Create a new kshark session. */
>   	kshark_ctx = NULL;
> diff --git a/examples/datafilter.c b/examples/datafilter.c
> index 8e86d9c..21a38fe 100644
> --- a/examples/datafilter.c
> +++ b/examples/datafilter.c
> @@ -23,6 +23,7 @@ int main(int argc, char **argv)
>   	struct kshark_entry **data = NULL;
>   	int *pids, *evt_ids;
>   	char *entry_str;
> +	int rt;

'sd' should be of type int. No need to declare 'rt'.

>   
>   	/* Create a new kshark session. */
>   	kshark_ctx = NULL;
> @@ -31,15 +32,17 @@ int main(int argc, char **argv)
>   
>   	/* Open a trace data file produced by trace-cmd. */
>   	if (argc > 1)
> -		sd = kshark_open(kshark_ctx, argv[1]);
> +		rt = kshark_open(kshark_ctx, argv[1]);
>   	else
> -		sd = kshark_open(kshark_ctx, default_file);
> +		rt = kshark_open(kshark_ctx, default_file);
>   
> -	if (sd < 0) {
> +	if (rt < 0) {
>   		kshark_free(kshark_ctx);
>   		return 1;
>   	}
>   
> +	sd = (size_t)rt;
> +
>   	/* Load the content of the file into an array of entries. */
>   	n_rows = kshark_load_entries(kshark_ctx, sd, &data);
>   
> diff --git a/examples/datahisto.c b/examples/datahisto.c
> index 568072d..b54b9e9 100644
> --- a/examples/datahisto.c
> +++ b/examples/datahisto.c
> @@ -70,7 +70,7 @@ void dump_bin(struct kshark_trace_histo *histo, int bin, int sd,
>   
>   void dump_histo(struct kshark_trace_histo *histo, int sd, const char *type, int val)
>   {
> -	size_t bin;
> +	int bin;
>   
>   	for (bin = 0; bin < histo->n_bins; ++bin)
>   		dump_bin(histo, bin, sd, type, val);
> diff --git a/src/libkshark-collection.c b/src/libkshark-collection.c
> index 915983b..2ce113f 100644
> --- a/src/libkshark-collection.c
> +++ b/src/libkshark-collection.c
> @@ -518,14 +518,16 @@ static int
>   map_collection_front_request(const struct kshark_entry_collection *col,
>   			     struct kshark_entry_request *req)
>   {
> -	size_t req_first, req_end;
> -	ssize_t col_index;
> +	size_t req_first, req_end, col_index;
> +	ssize_t r;

We are trying to use self explanatory variable names  if possible.
In many places in the code for variables like this one we use 'ret'.

>   	int req_count;
>   
> -	col_index = map_collection_request_init(col, req, true, &req_end);
> -	if (col_index == KS_EMPTY_BIN)
> +	r = map_collection_request_init(col, req, true, &req_end);
> +	if (r == KS_EMPTY_BIN)
>   		return 0;
>   
> +	col_index = (size_t)r;
> +
>   	/*
>   	 * Now loop over the intervals of the collection going forwards till
>   	 * the end of the inputted request and create a separate request for
> @@ -746,7 +748,7 @@ kshark_find_data_collection(struct kshark_entry_collection *col,
>   	while (col) {
>   		if (col->cond == cond &&
>   		    col->stream_id == sd &&
> -		    col->n_val == n_val &&
> +		    (size_t)col->n_val == n_val &&
>   		    val_compare(col->values, values, n_val))
>   				return col;
>   
> @@ -899,7 +901,7 @@ void kshark_unregister_data_collection(struct kshark_entry_collection **col,
>   	for (list = *col; list; list = list->next) {
>   		if (list->cond == cond &&
>   		    list->stream_id == sd &&
> -		    list->n_val == n_val &&
> +		    (size_t)list->n_val == n_val &&
>   		    val_compare(list->values, values, n_val)) {
>   			*last = list->next;
>   			kshark_free_data_collection(list);
> diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
> index 49f957b..0694e19 100644
> --- a/src/libkshark-configio.c
> +++ b/src/libkshark-configio.c
> @@ -1117,7 +1117,8 @@ static bool kshark_event_filter_to_json(struct kshark_data_stream *stream,
>   	json_object *jfilter_data, *jname;
>   	struct kshark_hash_id *filter;
>   	char *name_str;
> -	int i, *ids;
> +	int *ids;
> +	size_t i;
>   
>   	filter = kshark_get_filter(stream, filter_type);
>   	if (!filter)
> @@ -1286,7 +1287,8 @@ static bool kshark_filter_array_to_json(struct kshark_hash_id *filter,
>   					struct json_object *jobj)
>   {
>   	json_object *jfilter_data, *jpid = NULL;
> -	int i, *ids;
> +	int *ids;
> +	size_t i;
>   
>   	/*
>   	 * If this Json document already contains a description of the filter,
> diff --git a/src/libkshark-hash.c b/src/libkshark-hash.c
> index 89c021b..d4f0a31 100644
> --- a/src/libkshark-hash.c
> +++ b/src/libkshark-hash.c
> @@ -169,7 +169,7 @@ void kshark_hash_id_clear(struct kshark_hash_id *hash)
>   {
>   	struct kshark_hash_id_item *item, *next;
>   	size_t size;
> -	int i;
> +	size_t i;
>   
>   	if (!hash || ! hash->hash)
>   		return;
> @@ -212,7 +212,8 @@ int *kshark_hash_ids(struct kshark_hash_id *hash)
>   {
>   	struct kshark_hash_id_item *item;
>   	size_t size = hash_size(hash);
> -	int count = 0, i;
> +	size_t i;
> +	int count = 0;
>   	int *ids;
>   
>   	if (!hash->count)
> diff --git a/src/libkshark-model.c b/src/libkshark-model.c
> index 4cd9f6a..2918567 100644
> --- a/src/libkshark-model.c
> +++ b/src/libkshark-model.c
> @@ -97,6 +97,8 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
>   	int64_t corrected_range, delta_range, range = max - min;
>   	struct kshark_entry *last;
>   
> +	assert(min <= max);
Having this assert() makes it safe to declare 'range' as size_t.

> +
>   	if (n <= 0) {
>   		histo->n_bins = histo->bin_size = 0;
>   		histo->min = min;
> @@ -110,7 +112,7 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
>   	}
>   
>   	/* The size of the bin must be >= 1, hence the range must be >= n. */
> -	if (range < n) {
> +	if ((size_t)range < n) {
>   		range = n;
>   		max = min + n;
>   	}
> @@ -119,7 +121,7 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
>   	 * If the number of bins changes, allocate memory for the descriptor of
>   	 * the model.
>   	 */
> -	if (n != histo->n_bins) {

I think the problem here is that the function argument 'n' is declared
with wrong type. It must match the type of histo->n_bins which is int.

> +	if (n != (size_t)histo->n_bins) {
>   		if (!ksmodel_histo_alloc(histo, n)) {
>   			ksmodel_clear(histo);
>   			return;
> @@ -282,7 +284,7 @@ static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
>   	 * case we have to increase the size of the very last bin in order to
>   	 * make sure that the last entry of the dataset will fall into it.
>   	 */
> -	if (next_bin == histo->n_bins - 1)
> +	if (next_bin == (size_t)(histo->n_bins - 1))
>   		++time_max;
>   
>   	/*
> @@ -544,7 +546,7 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
>   void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n)
>   {
>   	size_t last_row = 0;
> -	int bin;
> +	size_t bin;
>   
>   	if (!histo->data_size)
>   		return;
> @@ -561,7 +563,7 @@ void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n)
>   	histo->min -= n * histo->bin_size;
>   	histo->max -= n * histo->bin_size;
>   
> -	if (n >= histo->n_bins) {
> +	if (n >= (size_t)histo->n_bins) {
>   		/*
>   		 * No overlap between the new and the old range. Recalculate
>   		 * all bins from scratch. First calculate the new range.
> @@ -649,7 +651,7 @@ void ksmodel_jump_to(struct kshark_trace_histo *histo, int64_t ts)
>   static void ksmodel_zoom(struct kshark_trace_histo *histo,
>   			 double r, int mark, bool zoom_in)
>   {
> -	size_t range, min, max, delta_min;
> +	int64_t range, min, max, delta_min;
>   	double delta_tot;
>   
>   	if (!histo->data_size)
> @@ -668,7 +670,7 @@ static void ksmodel_zoom(struct kshark_trace_histo *histo,
>   	 * Avoid overzooming. If needed, adjust the Scale factor to a the value
>   	 * which provides bin_size >= 5.
>   	 */
> -	if (zoom_in && (size_t) (range * (1. - r)) < histo->n_bins * 5)
> +	if (zoom_in && (int)(range * (1. - r)) < (histo->n_bins * 5))
>   		r = 1. - (histo->n_bins * 5.) / range;
>   
>   	/*
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index a178de6..4171fab 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -239,7 +239,7 @@ static int get_next_pid(struct kshark_data_stream *stream,
>   	ret = tep_read_number_field(get_sched_next(stream),
>   				    record->data, &val);
>   
> -	return ret ? : val;
> +	return ret ? : (int)val;
>   }
>   
>   static void register_command(struct kshark_data_stream *stream,
> diff --git a/src/libkshark.c b/src/libkshark.c
> index 44e553f..698b8d6 100644
> --- a/src/libkshark.c
> +++ b/src/libkshark.c
> @@ -1371,9 +1371,10 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
>   {
>   	struct kshark_data_stream *stream;
>   	int *stream_ids, i;
> +	size_t j;
>   
> -	for (i = 0; i < n_entries; ++i)
> -		set_all_visible(&data[i]->visible);
> +	for (j = 0; j < n_entries; ++j)
> +		set_all_visible(&data[j]->visible);
>   
>   	stream_ids = kshark_all_streams(kshark_ctx);
>   	for (i = 0; i < kshark_ctx->n_streams; i++) {
> @@ -1942,7 +1943,7 @@ kshark_merge_data_entries(struct kshark_entry_data_set *buffers, int n_buffers)
>   		return NULL;
>   	}
>   
> -	for (i = 0; i < n_buffers; ++i) {
> +	for (i = 0; i < (size_t)n_buffers; ++i) {
>   		count[i] = 0;
>   		if (buffers[i].n_rows > 0)
>   			tot += buffers[i].n_rows;
> @@ -2111,7 +2112,7 @@ kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers, int n_buffers
>   {
>   	struct kshark_matrix_data_set merged_data;
>   	size_t i, tot = 0, count[n_buffers];

Note that 'n_buffers' must be size_t as well. Better fix this.

> -	int i_first;
> +	int i_first, j;
>   	bool status;
>   
>   	merged_data.n_rows = -1;
> @@ -2121,10 +2122,10 @@ kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers, int n_buffers
>   		goto end;
>   	}
>   
> -	for (i = 0; i < n_buffers; ++i) {
> -		count[i] = 0;
> -		if (buffers[i].n_rows > 0)
> -			tot += buffers[i].n_rows;
> +	for (j = 0; j < n_buffers; ++j) {
> +		count[j] = 0;
> +		if (buffers[j].n_rows > 0)
> +			tot += buffers[j].n_rows;
>   	}
>   
>   	status = kshark_data_matrix_alloc(tot, &merged_data.event_array,
> diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
> index c3a4f47..a605fca 100644
> --- a/src/plugins/sched_events.c
> +++ b/src/plugins/sched_events.c
> @@ -115,7 +115,7 @@ static void plugin_sched_swith_action(struct kshark_data_stream *stream,
>   	ret = tep_read_number_field(plugin_ctx->sched_switch_next_field,
>   				    record->data, &next_pid);
>   
> -	if (ret == 0 && next_pid >= 0) {
> +	if (ret == 0) {
>   		plugin_sched_set_pid(&ks_field, entry->pid);
>   
>   		ret = tep_read_number_field(plugin_ctx->sched_switch_prev_state_field,
