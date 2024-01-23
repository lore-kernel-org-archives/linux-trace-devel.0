Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA13712BF3D
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 00:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968957; cv=none; b=tMIROyQhKiZIcjjQyXjJJlH3FrDp59vH1w6gmHVBsXY3Be+Pvfb547xcn3q81EmgqiIonjcOg0ZWMC1a6U7BYnfhq/Gsi/M3kD8x/SrUMclaXqAhIx+n2IxAXPvRhShSLCSNrdRp++thLEhbi7sIjLWNKWL9QYEiwHdA/n4JVjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968957; c=relaxed/simple;
	bh=YVPzjlC69r/ZOzQXY6NhfKvtU66KqMZWr4+xjjuknbk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DcJLIzxOEB/HQXWNw0JBUqjnN0atHUN3IQF/7hhqQHXd+0OvkhQNl0HC6lso5XDhSl5NBQxraXbKc3rrq2niQPI44AWbL01pePnJ8YajE/8tG8d4pnjU/r2bAgOe79fFmZVgxBBSs97pFJ4S53wkv/1vLJI5z8+g6S3i0kor5/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238D5C43394;
	Tue, 23 Jan 2024 00:15:57 +0000 (UTC)
Date: Mon, 22 Jan 2024 19:17:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] trace-cmd split: Store instances in local list
Message-ID: <20240122191726.27cd04e7@gandalf.local.home>
In-Reply-To: <20240122164336.167256-4-pierre.gondois@arm.com>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
	<20240122164336.167256-4-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jan 2024 17:43:32 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> To prepare handling of multiple instances, store instance
> handles in a local list, similarly to what is currently
> done in tracecmd/trace-read.c.
> 
> To help achieve this goal, add a 'struct handle_list' and
> add_handle()/free_handles() functions. 'struct handle' elements
> are added to the static list, but not used in this patch.
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> ---
>  tracecmd/trace-split.c | 60 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
> index b6c056b5..f46813d1 100644
> --- a/tracecmd/trace-split.c
> +++ b/tracecmd/trace-split.c
> @@ -19,10 +19,12 @@
>  #include <ctype.h>
>  #include <errno.h>
>  
> +#include "list.h"
>  #include "trace-local.h"
>  
>  static unsigned int page_size;
>  static const char *default_input_file = DEFAULT_INPUT_FILE;
> +static const char *default_top_instance_name = "top";
>  static const char *input_file;
>  
>  enum split_types {
> @@ -49,6 +51,46 @@ struct cpu_data {
>  	char				*file;
>  };
>  
> +struct handle_list {
> +	struct list_head		list;
> +	const char			*name;
> +	int				index;
> +
> +	/* Identify the top instance in the input trace. */
> +	bool				was_top_instance;
> +
> +	/* Identify the top instance in each output trace. */
> +	bool				is_top_instance;
> +};
> +
> +static struct list_head handle_list;
> +
> +static void add_handle(const char *name, int index, bool was_top_instance)
> +{
> +	struct handle_list *item;
> +
> +	item = calloc(1, sizeof(*item));
> +	if (!item)
> +		die("Failed to allocate handle item");
> +
> +	item->name = strdup(name);

Nit, need to check for strdup() errors.

-- Steve

> +	item->index = index;
> +	item->was_top_instance = was_top_instance;
> +	list_add_tail(&item->list, &handle_list);
> +}
> +
