Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729312AbeHOSJY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 14:09:24 -0400
Date: Wed, 15 Aug 2018 11:16:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] kernel-shark-qt: Add an example showing how to
 import/export config. data
Message-ID: <20180815111647.6a863796@gandalf.local.home>
In-Reply-To: <20180814180348.17236-3-y.karadz@gmail.com>
References: <20180814180348.17236-1-y.karadz@gmail.com>
        <20180814180348.17236-3-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 14 Aug 2018 21:03:48 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> This patch introduces a basic example, showing how to use the
> C API of KernelShark to import/export configuration data.
> 

Maybe this is a good way for me to describe what I'm trying to get at.

> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/examples/CMakeLists.txt |  4 ++
>  kernel-shark-qt/examples/configio.c     | 67 +++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
>  create mode 100644 kernel-shark-qt/examples/configio.c
> 
> diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/examples/CMakeLists.txt
> index 6906eba..a3745fa 100644
> --- a/kernel-shark-qt/examples/CMakeLists.txt
> +++ b/kernel-shark-qt/examples/CMakeLists.txt
> @@ -11,3 +11,7 @@ target_link_libraries(dfilter   kshark)
>  message(STATUS "datahisto")
>  add_executable(dhisto          datahisto.c)
>  target_link_libraries(dhisto   kshark)
> +
> +message(STATUS "confogio")
> +add_executable(confio          configio.c)
> +target_link_libraries(confio   kshark)
> diff --git a/kernel-shark-qt/examples/configio.c b/kernel-shark-qt/examples/configio.c
> new file mode 100644
> index 0000000..b7efad1
> --- /dev/null
> +++ b/kernel-shark-qt/examples/configio.c
> @@ -0,0 +1,67 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +#include "libkshark.h"
> +
> +int main(int argc, char **argv)
> +{
> +	struct kshark_config_doc *conf, *filter, *hello;
> +	struct kshark_context *kshark_ctx;
> +	int *ids, i;
> +
> +	/* Create a new kshark session. */
> +	kshark_ctx = NULL;
> +	if (!kshark_instance(&kshark_ctx))
> +		return 1;
> +
> +	if (argc == 1) {
> +		tracecmd_filter_id_add(kshark_ctx->show_task_filter, 314);
> +		tracecmd_filter_id_add(kshark_ctx->show_task_filter, 42);
> +
> +		/* Create a new Confog. doc. */
> +		conf = kshark_config_new("foo.bar.config", KS_JSON_CONFIG);
> +
> +		/* Add filter's info. */
> +		filter = kshark_export_all_filters(kshark_ctx);
> +		kshark_config_doc_add(conf, "Filters" ,filter);
> +
> +		/* Add "Hello Kernel" message. */
> +		hello = kshark_string_config_alloc();
> +		hello->conf_doc = "Hello Kernel";
> +		kshark_config_doc_add(conf, "Message" ,hello);

What I meant by having the API at too low of a level, is that instead
of having to do:

		hello = kshark_string_config_alloc();
		hello->conf_doc = "Hello Kernel";
		kshark_config_doc_add(conf, "Message", hello);

We should have:

		kshark_config_doc_add_message(conf, "Hello Kernel");

And that be something that does everything we need.

> +
> +		/* Save to file. */
> +		kshark_save_config_file("conf.json", conf);
> +	} else {
> +		/* Open a Config. file. */
> +		conf = kshark_open_config_file(argv[1], "foo.bar.config");
> +
> +		/* Retriever the filter's info. */
> +		filter = kshark_config_alloc(KS_JSON_CONFIG);
> +		if (!kshark_config_doc_get(conf, "Filters" ,filter))
> +			return 1;
> +
> +		kshark_import_all_filters(kshark_ctx, filter);
> +
> +		/* Get the array of Ids to be fitered. */
> +		ids = tracecmd_filter_ids(kshark_ctx->show_task_filter);

Instead of having to do:

		filter = kshark_config_alloc(KS_JSON_CONFIG);
		kshark_config_doc_get(conf, "Filters", filter);
		kshark_import_all_filters(kshark_ctx, filter);
		ids = tracecmd_filter_ids(...);

We should have:

		ids = kshark_doc_get_all_filters(kshark_ctx, conf);

See what I'm trying to get at. Think higher level. The API should be
the functionality we want, not the implementation level. Abstract that
part out.

Make sense?

-- Steve


> +		for (i = 0; i < kshark_ctx->show_task_filter->count; ++i)
> +			printf("pid: %i\n", ids[i]);
> +
> +		/* Retriever the message. */
> +		hello = kshark_string_config_alloc();
> +		kshark_config_doc_get(conf, "Message" ,hello);
> +
> +		puts((char *) hello->conf_doc);
> +
> +		free(filter);
> +		free(hello);
> +		free(ids);
> +	}
> +
> +	kshark_free_config_doc(conf);
> +
> +	kshark_free(kshark_ctx);
> +
> +	return 0;
> +}
