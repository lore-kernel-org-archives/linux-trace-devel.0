Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45201C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 15:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18BB22081C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 15:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfECPrM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 11:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfECPrM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 11:47:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D352081C;
        Fri,  3 May 2019 15:47:11 +0000 (UTC)
Date:   Fri, 3 May 2019 11:47:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Fix crash when trace-cmd is executed
 with args "profile -F sleep 1"
Message-ID: <20190503114709.76664a9f@gandalf.local.home>
In-Reply-To: <20190502120952.20449-1-tstoyanov@vmware.com>
References: <20190502120952.20449-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  2 May 2019 15:09:51 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> A fix for https://bugzilla.kernel.org/show_bug.cgi?id=203411

This should be a tag below.

> When trace-cmd is running in "profile" mode, trace files are not generated.
> Instead, pipes are used to collect trace data from recorder threads. Some
> internal functions, originally designed for working with files, are reused
> in pipes use case:
>  init_cpu()
>  allocate_page()
>  get_next_page()
> There was an undesired behaviour in those functions, when working with pipes,
> which causes the segmentation fault, described in the bug report.

Also, the full description should always be used in the commit log. If
the bugzilla server were to one day disappear, we would lose that
information.

> 

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203411

Also, I bisected this down to:

Fixes: 62e82cc6cdc9 ("trace-cmd: Use lookup table instead of link list for pages")

Please add that tag too.

> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  lib/trace-cmd/trace-input.c | 69 ++++++++++++++++++++++++-------------
>  1 file changed, 45 insertions(+), 24 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index ba20ef1..8d1001a 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -62,6 +62,7 @@ struct cpu_data {
>  	struct list_head	page_maps;
>  	struct page_map		*page_map;
>  	struct page		**pages;
> +	int			num_pages;

This should be placed next to the other "int"s in the structure.
Placing it here will cause a "hole" in the data. As on 64 bit, most
compilers will try to keep the 8 byte words aligned by 8 bytes (not
always, but mostly). An int is 4 bytes, so the compiler will likely pad
the structure with 4 bytes of zeros, creating that "hole".

Also, let's call this: nr_pages

as that is more in sync with what we use for counting objects in
structures (and is a common notation in the Linux kernel).

>  	struct tep_record	*next;
>  	struct page		*page;
>  	struct kbuffer		*kbuf;
> @@ -921,34 +922,50 @@ static struct page *allocate_page(struct tracecmd_input *handle,
>  	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
>  	struct page *page;
>  	int index;
> +	int ret;
>  
>  	index = (offset - cpu_data->file_offset) / handle->page_size;
> -	if (cpu_data->pages[index]) {
> -		cpu_data->pages[index]->ref_count++;
> -		return cpu_data->pages[index];
> -	}
> -
> -	page = malloc(sizeof(*page));
> -	if (!page)
> +	if (index >= cpu_data->num_pages)
>  		return NULL;

I'm not sure if this is correct. Looking at the patch that broke this
we have:

@@ -907,12 +913,12 @@ static struct page *allocate_page(struct tracecmd_input *handle,
 {
        struct cpu_data *cpu_data = &handle->cpu_data[cpu];
        struct page *page;
+       int index;
 
-       list_for_each_entry(page, &cpu_data->pages, list) {
-               if (page->offset == offset) {
-                       page->ref_count++;
-                       return page;
-               }
+       index = (offset - cpu_data->file_offset) / handle->page_size;
+       if (cpu_data->pages[index]) {
+               cpu_data->pages[index]->ref_count++;
+               return cpu_data->pages[index];
        }
 

Which shows to me that we would continue if index didn't match.

So I would like to go back to that broken commit, and see exactly how
the profile code worked before, and make make it work the same way again.

Just making it not crash, doesn't mean that it works.

Thanks!

-- Steve


> +	page = cpu_data->pages[index];
> +	if (page && !handle->read_page) {
> +		page->ref_count++;
> +		return page;
> +	}
>  
> -	memset(page, 0, sizeof(*page));
> -	page->offset = offset;
> -	page->handle = handle;
> -	page->cpu = cpu;
> +	if (!page) {
> +		page = malloc(sizeof(*page));
> +		if (!page)
> +			return NULL;
>  
> -	page->map = allocate_page_map(handle, page, cpu, offset);
> +		memset(page, 0, sizeof(*page));
> +		page->offset = offset;
> +		page->handle = handle;
> +		page->cpu = cpu;
> +	}
>  
>  	if (!page->map) {
> -		free(page);
> -		return NULL;
> +		page->map = allocate_page_map(handle, page, cpu, offset);
> +		if (!page->map) {
> +			free(page);
> +			return NULL;
> +		}
> +
> +		cpu_data->pages[index] = page;
> +		cpu_data->page_cnt++;
> +		page->ref_count = 1;
> +
> +		return page;
>  	}
>  
> -	cpu_data->pages[index] = page;
> -	cpu_data->page_cnt++;
> -	page->ref_count = 1;
> +	if (handle->read_page) {
> +		ret = read_page(handle, offset, cpu, page->map);
> +		if (ret < 0)
> +			return NULL;
> +		return page;
> +	}
>  
> -	return page;
> +	return NULL;
>  }
>  
>  static void __free_page(struct tracecmd_input *handle, struct page *page)
> @@ -960,6 +977,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
>  		die("Page ref count is zero!\n");
>  
>  	page->ref_count--;
> +	if (cpu_data->page == page)
> +		cpu_data->page = NULL;
>  	if (page->ref_count)
>  		return;
>  
> @@ -1125,7 +1144,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
>  
>  static int get_next_page(struct tracecmd_input *handle, int cpu)
>  {
> -	off64_t offset;
> +	off64_t offset = 0;
>  
>  	if (!handle->cpu_data[cpu].page && !handle->use_pipe)
>  		return 0;
> @@ -1137,7 +1156,8 @@ static int get_next_page(struct tracecmd_input *handle, int cpu)
>  		return 0;
>  	}
>  
> -	offset = handle->cpu_data[cpu].offset + handle->page_size;
> +	if (!handle->use_pipe)
> +		offset = handle->cpu_data[cpu].offset + handle->page_size;
>  
>  	return get_page(handle, cpu, offset);
>  }
> @@ -2026,7 +2046,6 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
>  static int init_cpu(struct tracecmd_input *handle, int cpu)
>  {
>  	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
> -	int num_pages;
>  	int i;
>  
>  	cpu_data->offset = cpu_data->file_offset;
> @@ -2040,13 +2059,13 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
>  		return 0;
>  	}
>  
> -	num_pages = (cpu_data->size + handle->page_size - 1) / handle->page_size;
> -	cpu_data->pages = calloc(num_pages + 1, sizeof(*cpu_data->pages));
> +	cpu_data->num_pages = (cpu_data->size + handle->page_size - 1) / handle->page_size;
> +	cpu_data->pages = calloc(cpu_data->num_pages + 1, sizeof(*cpu_data->pages));
>  	if (!cpu_data->pages)
>  		return -1;
>  
>  	/* Add stopper */
> -	cpu_data->pages[num_pages] = PAGE_STOPPER;
> +	cpu_data->pages[cpu_data->num_pages] = PAGE_STOPPER;
>  
>  	if (handle->use_pipe) {
>  		/* Just make a page, it will be nuked later */
> @@ -2056,8 +2075,10 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
>  
>  		memset(cpu_data->page, 0, sizeof(*cpu_data->page));
>  		cpu_data->pages[0] = cpu_data->page;
> +		cpu_data->num_pages = 1;
>  		cpu_data->page_cnt = 1;
>  		cpu_data->page->ref_count = 1;
> +		cpu_data->page->cpu = cpu;
>  		return 0;
>  	}
>  

