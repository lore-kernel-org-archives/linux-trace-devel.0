Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C113319BCF
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 19:54:55 +0000 (UTC)
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2417CB3
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 12:54:52 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-3513b5a9e8eso483355ab.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Oct 2023 12:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696276491; x=1696881291; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8HNLYrVfsJTN0tNNvFRV3qMLQs2MEeAo5ZpazvrhXcc=;
        b=NJ7+AfEQn0CK4ctCfX1dlniLj8FWUG+QEtihX60YkaSslVUJt/a+ym6D0zxh5G2SiY
         pZ4rUb2SCTydNuvRozzWHuY+pCozAtGXQmUEGrXXtgoVC8vtY6xJJYouJejxiyVwa94T
         ibEkPjc8XgJWUDMa3T/pjmu0SU3k3ysuNRrObuvvoHpaUPxmQt8T1zZd6oItIjo+sdDV
         2pXMK3SpZcNqeZVNEsDO+zancrJqmFUbzZfaz1lKvsEukR8jzlbgz8WHfAG1BzrhEQU+
         W1CUj47TC+/q+NBWCAofYopNHesqr1I2qu25viJ2A1d19OVDG452HJNaLurV1xYIpj3R
         i3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696276491; x=1696881291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HNLYrVfsJTN0tNNvFRV3qMLQs2MEeAo5ZpazvrhXcc=;
        b=tfpys0lNDsGbgpsRfvkyOu2yGWxozH/RHfWnoCZhlAPaRfsSoSrMpsJoQRmJ9zw6bx
         vFGYryBQolsk9wKt5XXRsar3PcosoE9jD1exsGIplTs3NKfjFTdZkFtvDbyB/7q66f8c
         CV0G7CxgcELoyRl+MTxamQrEH9oA91f+WXenBupSEnHMKK83k3K69CNBjpQzaOZT+oKs
         /b7gcTRJIIMJyhaD5XS5fb7u23l7wY+Mp+lv/MqpFIdnM/oeeR6kusmciHamdIyDICsx
         gCaHlOOQ40iVbFTP7ijXW7lc97uiDYgqErRSupgCv69K7ho/TsfZwOGV+Mhna6RQW7TF
         cDAQ==
X-Gm-Message-State: AOJu0YyFvFSOapCMrQDFuqfNWtfWjFhvI6iAmRgsBNwBB830V9KsKQsq
	J/8ceqdH0lUUhwA1WMpI3eZI6LO6IhuWHbSwmzKlCQ==
X-Google-Smtp-Source: AGHT+IHrPjcAeXa2WHJ+Mq6WoGx5yS2dssLBJTLGzUPpv58YM+RT+FZhorkwJvgJI7QJn0NbFhFRDg==
X-Received: by 2002:a05:6e02:1d19:b0:350:f51b:c32e with SMTP id i25-20020a056e021d1900b00350f51bc32emr17079597ila.16.1696276491329;
        Mon, 02 Oct 2023 12:54:51 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:8fce:2797:9aee:7ec7])
        by smtp.gmail.com with ESMTPSA id q23-20020a02c8d7000000b0042b530d29c3sm6923290jao.164.2023.10.02.12.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 12:54:50 -0700 (PDT)
Date: Mon, 2 Oct 2023 13:54:48 -0600
From: Ross Zwisler <zwisler@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 06/11] libtraceeval histogram: Add type to
 traceeval_data and make it a structure
Message-ID: <20231002195448.GD1532181@google.com>
References: <20230927123314.989589-1-rostedt@goodmis.org>
 <20230927123314.989589-7-rostedt@goodmis.org>
 <20231002195304.GC1532181@google.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002195304.GC1532181@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Oct 02, 2023 at 01:53:04PM -0600, Ross Zwisler wrote:
> On Wed, Sep 27, 2023 at 08:33:09AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Having a straight union for passing in the data that must match the types
> > is dangerous and prone for buggy code. If some data doesn't match its
> > type, there's nothing to catch it.
> > 
> > Instead of having a union traceeval_data of each type, have it be a
> > structure with a "type" field follow by a union, where the type defines
> > what kind of data it is.
> > 
> > Add helper macros to make it easy to define the data when using it.
> > 
> > Reviewed-by: Ross Zwisler <zwisler@google.com>
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  include/traceeval-hist.h |  90 ++++++++++++++++---------
> >  samples/task-eval.c      | 139 ++++++++++++++++-----------------------
> >  src/eval-local.h         |   4 +-
> >  src/histograms.c         |  70 ++++++++++----------
> >  4 files changed, 153 insertions(+), 150 deletions(-)
> > 
> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > index e619d52ea0d0..78cfac5982ee 100644
> > --- a/include/traceeval-hist.h
> > +++ b/include/traceeval-hist.h
> > @@ -52,45 +52,75 @@ struct traceeval_dynamic {
> >   * Trace data entry for a traceeval histogram
> >   * Constitutes keys and values.
> >   */
> > -union traceeval_data {
> > -	struct traceeval_dynamic	dyn_data;
> > -	char				*string;
> > -	const char			*cstring;
> > -	void				*pointer;
> > -	unsigned long			number;
> > -	unsigned long long		number_64;
> > -	unsigned int			number_32;
> > -	unsigned short			number_16;
> > -	unsigned char			number_8;
> > +struct traceeval_data {
> > +	enum traceeval_data_type		type;
> > +	union {
> > +		struct traceeval_dynamic	dyn_data;
> > +		char				*string;
> > +		const char			*cstring;
> > +		void				*pointer;
> > +		unsigned long			number;
> > +		unsigned long long		number_64;
> > +		unsigned int			number_32;
> > +		unsigned short			number_16;
> > +		unsigned char			number_8;
> > +	};
> >  };
> >  
> > +#define __TRACEEVAL_DATA(data_type, member, data)			\
> > +	{  .type = TRACEEVAL_TYPE_##data_type, .member = (data) }
> > +
> > +#define DEFINE_TRACEEVAL_NUMBER(data)	   __TRACEEVAL_DATA(NUMBER, number, data)
> > +#define DEFINE_TRACEEVAL_NUMBER_8(data)	   __TRACEEVAL_DATA(NUMBER_8, number_8, data)
> > +#define DEFINE_TRACEEVAL_NUMBER_16(data)   __TRACEEVAL_DATA(NUMBER_16, number_16, data)
> > +#define DEFINE_TRACEEVAL_NUMBER_32(data)   __TRACEEVAL_DATA(NUMBER_32, number_32, data)
> > +#define DEFINE_TRACEEVAL_NUMBER_64(data)   __TRACEEVAL_DATA(NUMBER_64, number_64, data)
> > +#define DEFINE_TRACEEVAL_STRING(data)	   __TRACEEVAL_DATA(STRING, string, data)
> > +#define DEFINE_TRACEEVAL_CSTRING(data)	   __TRACEEVAL_DATA(STRING, cstring, data)
> > +#define DEFINE_TRACEEVAL_POINTER(data)	   __TRACEEVAL_DATA(POINTER, pointer, data)
> > +
> > +#define __TRACEEVAL_SET(data, data_type, member, val)		\
> > +	do {							\
> > +		(data).type = TRACEEVAL_TYPE_##data_type;	\
> > +		(data).member = (val);				\
> > +	} while (0)
> > +
> > +#define TRACEEVAL_SET_NUMBER(data, val)	     __TRACEEVAL_SET(data, NUMBER, number, val)
> > +#define TRACEEVAL_SET_NUMBER_8(data, val)    __TRACEEVAL_SET(data, NUMBER_8, number_8, val)
> > +#define TRACEEVAL_SET_NUMBER_16(data, val)   __TRACEEVAL_SET(data, NUMBER_16, number_16, val)
> > +#define TRACEEVAL_SET_NUMBER_32(data, val)   __TRACEEVAL_SET(data, NUMBER_32, number_32, val)
> > +#define TRACEEVAL_SET_NUMBER_64(data, val)   __TRACEEVAL_SET(data, NUMBER_64, number_64, val)
> > +#define TRACEEVAL_SET_STRING(data, val)	     __TRACEEVAL_SET(data, STRING, string, val)
> > +#define TRACEEVAL_SET_CSTRING(data, val)     __TRACEEVAL_SET(data, STRING, cstring, val)
> > +#define TRACEEVAL_SET_POINTER(data, val)     __TRACEEVAL_SET(data, POINTER, pointer, val)
> > +
> >  struct traceeval_type;
> >  struct traceeval;
> >  
> >  /* release function callback on traceeval_data */
> >  typedef void (*traceeval_data_release_fn)(const struct traceeval_type *type,
> > -					  union traceeval_data *data);
> > +					  struct traceeval_data *data);
> >  
> >  /* compare function callback to compare traceeval_data */
> >  typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
> >  				     const struct traceeval_type *type,
> > -				     const union traceeval_data *A,
> > -				     const union traceeval_data *B);
> > +				     const struct traceeval_data *A,
> > +				     const struct traceeval_data *B);
> >  
> >  /* make a unique value */
> >  typedef int (*traceeval_data_hash_fn)(struct traceeval *teval,
> >  				      const struct traceeval_type *type,
> > -				      const union traceeval_data *data);
> > +				      const struct traceeval_data *data);
> >  
> >  typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
> > -				      union traceeval_data *dst,
> > -				      const union traceeval_data *src);
> > +				      struct traceeval_data *dst,
> > +				      const struct traceeval_data *src);
> >  
> >  typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
> > -				const union traceeval_data *Akeys,
> > -				const union traceeval_data *Avals,
> > -				const union traceeval_data *Bkeys,
> > -				const union traceeval_data *Bvals,
> > +				const struct traceeval_data *Akeys,
> > +				const struct traceeval_data *Avals,
> > +				const struct traceeval_data *Bkeys,
> > +				const struct traceeval_data *Bvals,
> >  				void *data);
> >  
> >  /*
> > @@ -157,20 +187,20 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
> >  void traceeval_release(struct traceeval *teval);
> >  
> >  int traceeval_insert(struct traceeval *teval,
> > -		     const union traceeval_data *keys,
> > -		     const union traceeval_data *vals);
> > +		     const struct traceeval_data *keys,
> > +		     const struct traceeval_data *vals);
> >  
> >  int traceeval_remove(struct traceeval *teval,
> > -		     const union traceeval_data *keys);
> > +		     const struct traceeval_data *keys);
> >  
> > -int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
> > -		    const union traceeval_data **results);
> > +int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
> > +		    const struct traceeval_data **results);
> >  
> >  void traceeval_results_release(struct traceeval *teval,
> > -			       const union traceeval_data *results);
> > +			       const struct traceeval_data *results);
> >  
> >  struct traceeval_stat *traceeval_stat(struct traceeval *teval,
> > -				      const union traceeval_data *keys,
> > +				      const struct traceeval_data *keys,
> >  				      struct traceeval_type *type);
> >  
> >  unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
> > @@ -185,11 +215,11 @@ int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_fi
> >  int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
> >  				   traceeval_cmp_fn sort_fn, void *data);
> >  int traceeval_iterator_next(struct traceeval_iterator *iter,
> > -			    const union traceeval_data **keys);
> > +			    const struct traceeval_data **keys);
> >  int traceeval_iterator_query(struct traceeval_iterator *iter,
> > -			     const union traceeval_data **results);
> > +			     const struct traceeval_data **results);
> >  void traceeval_iterator_results_release(struct traceeval_iterator *iter,
> > -					const union traceeval_data *results);
> > +					const struct traceeval_data *results);
> >  struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
> >  					       struct traceeval_type *type);
> >  int traceeval_iterator_remove(struct traceeval_iterator *iter);
> > diff --git a/samples/task-eval.c b/samples/task-eval.c
> > index bde167d1219b..e62bfddafdd3 100644
> > --- a/samples/task-eval.c
> > +++ b/samples/task-eval.c
> > @@ -190,21 +190,15 @@ static void update_process(struct task_data *tdata, const char *comm,
> >  			   enum sched_state state, enum command cmd,
> >  			   unsigned long long ts)
> >  {
> > -	union traceeval_data keys[] = {
> > -		{
> > -			.cstring	= comm,
> > -		},
> > -		{
> > -			.number		= state,
> > -		},
> > +	struct traceeval_data keys[] = {
> > +		DEFINE_TRACEEVAL_CSTRING(	comm	),
> > +		DEFINE_TRACEEVAL_NUMBER(	state	),
> >  	};
> > -	union traceeval_data vals[] = {
> > -		{
> > -			.number_64	= ts,
> > -		},
> > +	struct traceeval_data vals[] = {
> > +		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
> >  	};
> > -	union traceeval_data new_vals[1] = { };
> > -	const union traceeval_data *results;
> > +	struct traceeval_data new_vals[1] = { };
> > +	const struct traceeval_data *results;
> >  	int ret;
> >  
> >  	switch (cmd) {
> > @@ -222,14 +216,15 @@ static void update_process(struct task_data *tdata, const char *comm,
> >  		if (!results[0].number_64)
> >  			break;
> >  
> > -		new_vals[0].number_64 = ts - results[0].number_64;
> > +		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
> >  
> >  		ret = traceeval_insert(tdata->teval_processes.stop, keys, new_vals);
> >  		if (ret < 0)
> >  			pdie("Could not stop process");
> >  
> >  		/* Reset the start */
> > -		new_vals[0].number_64 = 0;
> > +		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
> > +
> >  		ret = traceeval_insert(tdata->teval_processes.start, keys, new_vals);
> >  		if (ret < 0)
> >  			pdie("Could not start CPU");
> > @@ -253,15 +248,11 @@ static void stop_process(struct task_data *tdata, const char *comm,
> >  static struct process_data *
> >  get_process_data(struct task_data *tdata, const char *comm)
> >  {
> > -	union traceeval_data keys[] = {
> > -		{
> > -			.cstring = comm,
> > -		},
> > -		{
> > -			.number = RUNNING,
> > -		}
> > +	struct traceeval_data keys[] = {
> > +		DEFINE_TRACEEVAL_CSTRING(	comm	),
> > +		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
> >  	};
> > -	const union traceeval_data *results;
> > +	const struct traceeval_data *results;
> >  	void *data;
> >  	int ret;
> >  
> > @@ -278,16 +269,12 @@ get_process_data(struct task_data *tdata, const char *comm)
> >  
> >  void set_process_data(struct task_data *tdata, const char *comm, void *data)
> >  {
> > -	union traceeval_data keys[] = {
> > -		{
> > -			.cstring = comm,
> > -		},
> > -		{
> > -			.number = RUNNING,
> > -		}
> > +	struct traceeval_data keys[] = {
> > +		DEFINE_TRACEEVAL_CSTRING(	comm	),
> > +		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
> >  	};
> > -	union traceeval_data new_vals[1] = { };
> > -	const union traceeval_data *results;
> > +	struct traceeval_data new_vals[1] = { };
> > +	const struct traceeval_data *results;
> >  	int ret;
> >  
> >  	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
> > @@ -296,7 +283,7 @@ void set_process_data(struct task_data *tdata, const char *comm, void *data)
> >  	if (ret < 0)
> >  		pdie("Could not query process data");
> >  
> > -	new_vals[0].pointer = data;
> > +	TRACEEVAL_SET_POINTER(new_vals[0], data);
> >  	ret = traceeval_insert(tdata->teval_processes_data, keys, new_vals);
> >  	if (ret < 0)
> >  		pdie("Failed to set process data");
> > @@ -309,21 +296,15 @@ static void update_cpu(struct teval_pair *teval_pair, int cpu,
> >  		       enum sched_state state, enum command cmd,
> >  		       unsigned long long ts)
> >  {
> > -	const union traceeval_data *results;
> > -	union traceeval_data keys[] = {
> > -		{
> > -			.number = cpu,
> > -		},
> > -		{
> > -			.number = state,
> > -		}
> > +	const struct traceeval_data *results;
> > +	struct traceeval_data keys[] = {
> > +		DEFINE_TRACEEVAL_NUMBER(	cpu	),
> > +		DEFINE_TRACEEVAL_NUMBER(	state	),
> >  	};
> > -	union traceeval_data vals[] = {
> > -		{
> > -			.number_64	= ts,
> > -		},
> > +	struct traceeval_data vals[] = {
> > +		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
> >  	};
> > -	union traceeval_data new_vals[1] = { };
> > +	struct traceeval_data new_vals[1] = { };
> >  	int ret;
> >  
> >  	switch (cmd) {
> > @@ -350,14 +331,14 @@ static void update_cpu(struct teval_pair *teval_pair, int cpu,
> >  		if (!results[0].number_64)
> >  			break;
> >  
> > -		new_vals[0].number_64 = ts - results[0].number_64;
> > +		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
> >  
> >  		ret = traceeval_insert(teval_pair->stop, keys, new_vals);
> >  		if (ret < 0)
> >  			pdie("Could not stop CPU");
> >  
> >  		/* Reset the start */
> > -		new_vals[0].number_64 = 0;
> > +		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
> >  		ret = traceeval_insert(teval_pair->start, keys, new_vals);
> >  		if (ret < 0)
> >  			pdie("Could not start CPU");
> > @@ -385,21 +366,15 @@ static void update_thread(struct process_data *pdata, int tid,
> >  			  enum sched_state state, enum command cmd,
> >  			  unsigned long long ts)
> >  {
> > -	const union traceeval_data *results;
> > -	union traceeval_data keys[] = {
> > -		{
> > -			.number = tid,
> > -		},
> > -		{
> > -			.number = state,
> > -		}
> > +	const struct traceeval_data *results;
> > +	struct traceeval_data keys[] = {
> > +		DEFINE_TRACEEVAL_NUMBER(	tid	),
> > +		DEFINE_TRACEEVAL_NUMBER(	state	),
> >  	};
> > -	union traceeval_data vals[] = {
> > -		{
> > -			.number_64	= ts,
> > -		},
> > +	struct traceeval_data vals[] = {
> > +		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
> >  	};
> > -	union traceeval_data new_vals[1] = { };
> > +	struct traceeval_data new_vals[1] = { };
> >  	int ret;
> >  
> >  	switch (cmd) {
> > @@ -415,7 +390,7 @@ static void update_thread(struct process_data *pdata, int tid,
> >  		if (ret == 0)
> >  			return;
> >  
> > -		new_vals[0].number_64 = ts - results[0].number_64;
> > +		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
> >  
> >  		ret = traceeval_insert(pdata->teval_threads.stop, keys, new_vals);
> >  		traceeval_results_release(pdata->teval_threads.start, results);
> > @@ -646,17 +621,19 @@ static void print_microseconds(int idx, unsigned long long nsecs)
> >   *  If RUNNING is equal, then sort by COMM.
> >   */
> >  static int compare_pdata(struct traceeval *teval_data,
> > -				const union traceeval_data *Akeys,
> > -				const union traceeval_data *Avals,
> > -				const union traceeval_data *Bkeys,
> > -				const union traceeval_data *Bvals,
> > +				const struct traceeval_data *Akeys,
> > +				const struct traceeval_data *Avals,
> > +				const struct traceeval_data *Bkeys,
> > +				const struct traceeval_data *Bvals,
> >  				void *data)
> >  {
> >  	struct traceeval *teval = data; /* The deltas are here */
> > -	union traceeval_data keysA[] = {
> > -		{ .cstring = Akeys[0].cstring }, { .number = RUNNING } };
> > -	union traceeval_data keysB[] = {
> > -		{ .cstring = Bkeys[0].cstring }, { .number = RUNNING } };
> > +	struct traceeval_data keysA[] = {
> > +		DEFINE_TRACEEVAL_CSTRING(	Akeys[0].cstring	),
> > +		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
> > +	struct traceeval_data keysB[] = {
> > +		DEFINE_TRACEEVAL_CSTRING(	Bkeys[0].cstring	),
> > +		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
> >  	struct traceeval_stat *statA;
> >  	struct traceeval_stat *statB;
> >  	unsigned long long totalA = -1;
> > @@ -690,7 +667,7 @@ static int compare_pdata(struct traceeval *teval_data,
> >  static void display_cpus(struct traceeval *teval)
> >  {
> >  	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
> > -	const union traceeval_data *keys;
> > +	const struct traceeval_data *keys;
> >  	struct traceeval_stat *stat;
> >  	int last_cpu = -1;
> >  
> > @@ -762,7 +739,7 @@ static void display_state_times(int state, unsigned long long total)
> >  static void display_threads(struct traceeval *teval)
> >  {
> >  	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
> > -	const union traceeval_data *keys;
> > +	const struct traceeval_data *keys;
> >  	struct traceeval_stat *stat;
> >  	int last_tid = -1;
> >  
> > @@ -802,17 +779,13 @@ static void display_process_stats(struct traceeval *teval,
> >  {
> >  	struct traceeval_stat *stat;
> >  	unsigned long long delta;
> > -	union traceeval_data keys[] = {
> > -		{
> > -			.cstring = comm,
> > -		},
> > -		{
> > -			.number = RUNNING,
> > -		}
> > +	struct traceeval_data keys[] = {
> > +		DEFINE_TRACEEVAL_CSTRING(	comm		),
> > +		DEFINE_TRACEEVAL_NUMBER(	RUNNING		),
> >  	};
> >  
> >  	for (int i = 0; i < OTHER; i++) {
> > -		keys[1].number = i;
> > +		TRACEEVAL_SET_NUMBER_64(keys[1], i);
> 
> I think this should be 
> +		TRACEEVAL_SET_NUMBER(keys[1], i);
> 
> to match the 
> +		DEFINE_TRACEEVAL_NUMBER(	RUNNING		),
> 
> a little up in this function.

Ah, it looks like you fix this in the next patch.
