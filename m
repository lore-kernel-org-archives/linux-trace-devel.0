Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE4431595
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Oct 2023 22:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D65DC433C7;
	Tue, 10 Oct 2023 22:33:30 +0000 (UTC)
Date: Tue, 10 Oct 2023 18:34:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH 1/1] Fix incompatible function pointer types assigning
 to stream_find_id_func
Message-ID: <20231010183452.3ec7ac71@gandalf.local.home>
In-Reply-To: <20231010192738.166989-1-brahmajit.xyz@gmail.com>
References: <20231010192738.166989-1-brahmajit.xyz@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Yordan,

Not sure if you are following linux-trace-devel, but this is a kernelshark
patch.

-- Steve


On Tue, 10 Oct 2023 19:26:33 +0000
Brahmajit Das <brahmajit.xyz@gmail.com> wrote:

> Newer compilers such as Clang 16 and GCC 14 enables certain errors by
> default, -Werror=incompatible-function-pointer-types being one of them
> (-Werror=incompatible-pointer-types is the equivalent in GCC). This
> resutls in build errors such as
> 
> error: incompatible function pointer types assigning to 'stream_find_id_func' (aka 'int (*)(struct kshark_data_stream *, const char *)') from 'const int (struct kshark_data_stream *, const char *)' [-Wincompatible-function-pointer-types]
>  1204 |         interface->find_event_id = tepdata_find_event_id;
>       |                                  ^ ~~~~~~~~~~~~~~~~~~~~~
> 
> My patch is not the best fix/a proper fix but for now silences the error
> and lets me build kernelshark with clang.
> 
> I've also added some other misc. fixes that helps building kernelshark
> on musl libc.
> 
> Bug: https://bugs.gentoo.org/895838
> Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
> ---
>  src/kernelshark.cpp        | 1 +
>  src/libkshark-tepdata.c    | 6 +++---
>  src/libkshark.h            | 1 +
>  src/plugins/sched_events.c | 1 +
>  4 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
> index 1ad15f4..d795492 100644
> --- a/src/kernelshark.cpp
> +++ b/src/kernelshark.cpp
> @@ -7,6 +7,7 @@
>  // C
>  #include <sys/stat.h>
>  #include <getopt.h>
> +#include <libgen.h>
>  
>  // Qt
>  #include <QApplication>
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index b780957..236a858 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -1201,13 +1201,13 @@ static void kshark_tep_init_methods(struct kshark_generic_stream_interface *inte
>  	interface->get_event_name = tepdata_get_event_name;
>  	interface->aux_info= tepdata_get_latency;
>  	interface->get_info = tepdata_get_info;
> -	interface->find_event_id = tepdata_find_event_id;
> +	interface->find_event_id = (stream_find_id_func) tepdata_find_event_id;
>  	interface->get_all_event_ids = tepdata_get_event_ids;
>  	interface->dump_entry = tepdata_dump_entry;
>  	interface->get_all_event_field_names = tepdata_get_field_names;
>  	interface->get_event_field_type = tepdata_get_field_type;
> -	interface->read_record_field_int64 = tepdata_read_record_field;
> -	interface->read_event_field_int64 = tepdata_read_event_field;
> +	interface->read_record_field_int64 = (stream_read_record_field)tepdata_read_record_field;
> +	interface->read_event_field_int64 = (stream_read_event_field) tepdata_read_event_field;
>  	interface->load_entries = tepdata_load_entries;
>  	interface->load_matrix = tepdata_load_matrix;
>  }
> diff --git a/src/libkshark.h b/src/libkshark.h
> index 1514f33..c477c70 100644
> --- a/src/libkshark.h
> +++ b/src/libkshark.h
> @@ -17,6 +17,7 @@
>  #include <string.h>
>  #include <pthread.h>
>  #include <errno.h>
> +#include <sys/types.h>
>  
>  // Json-C
>  #include <json-c/json.h>
> diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
> index c3a4f47..fc5dc54 100644
> --- a/src/plugins/sched_events.c
> +++ b/src/plugins/sched_events.c
> @@ -14,6 +14,7 @@
>  #include <stdio.h>
>  
>  // trace-cmd
> +#define _GNU_SOURCE             /* See feature_test_macros(7) */
>  #include <trace-cmd.h>
>  
>  // KernelShark

