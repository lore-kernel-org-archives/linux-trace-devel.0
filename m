Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E48E2D3EF4
	for <linux-trace-devel@vger.kernel.org>; Fri, 15 Aug 2025 09:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755249957; cv=none; b=RvRU+kpGpJsKtPdR6yJd4IXK3dgnlUDankJYf8/QLMHAd0HECafmw1AVbPyMgHz0jOLO/BlD8QMZgS++eGkwjT6w0w05G5HCMT4upq/rcailbokEHyicgtuz9UGlHbc7aOKd9Hu1cSGrQ+6nf5IqRZQCu6b8gPHzcHjWxj6q5Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755249957; c=relaxed/simple;
	bh=n6OxIsGhrHbAscUDfFJPNX5Lxco5B7rnTXXQEdd6ZXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X5hq1FkNNvHCxt3bYmh3NhUAtezERuzkQqC8eRKfM0vgtV5J1QwrCHTe6pRH0HPTUwCDf2YsWQWsSExoOnVDg0cOBOiM+9RJFKYT4HJi/ccEz5THowvfS7n6L6RqnFYrIwddozwSbdNYBQCxv0POcMWjt64IaFJf5wUsMp/3+us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99AFE14BF;
	Fri, 15 Aug 2025 02:25:46 -0700 (PDT)
Received: from [10.57.2.63] (unknown [10.57.2.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 390703F63F;
	Fri, 15 Aug 2025 02:25:54 -0700 (PDT)
Message-ID: <c0d09a7e-c3a2-468d-a81d-cdef37f4c575@arm.com>
Date: Fri, 15 Aug 2025 10:25:52 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH] libtraceevent: Fix static library to hide hidden
 functions
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Douglas Raillard <douglas.raillard@arm.com>
References: <20250814144710.6c3458d4@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20250814144710.6c3458d4@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/08/2025 7:47 PM, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> When the static library uses the objects directly to be created, it makes
> all the hidden functions visible to applications that link to it.
> 
> If the static library is created via the shared object instead, the hidden
> functions are no longer visible. This allows to go back to simple names
> and not worry about name space collisions.
> 
> This reverts commit ecbf580c3a6ac ("libtraceevent: Rename private functions
> to prevent static build failures") and makes the static library use the
> shared library as its input.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> [
>    Note, when working on another library, I realized that I did not add name
>    space protection to the __hidden functions. Not wanting to change the
>    naming I was going to write program that would strip the symbols from the
>    static library. I started looking at the symbols of the shared library to
>    see how to do that. That's when I thought about using the shared library
>    as input to create the static library. When I did this, the hidden
>    symbols were no longer visible to the static library.
> 
>    I think doing this trick is much better than renaming all the internal
>    "global" functions to have name space protecting naming.
> 
>    Care to test this?

Hi Steven,

I tried cherry-picking this patch on my stash (my HEAD is "b3f5849 - 
libtraceevent: Save missed events in kbuffer_read_buffer()"), but it failed:

error: patch failed: src/event-parse-local.h:111
error: src/event-parse-local.h: patch does not apply
error: patch failed: src/event-parse.c:8724
error: src/event-parse.c: patch does not apply

Thus, I reverted "ecbf580 - libtraceevent: Rename private functions to 
prevent static build failures" first, and made manual adjustments 
similar to your patch:

diff --git a/src/Makefile b/src/Makefile
index 53bb570..44c82f5 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
  $(bdir)/%.o: %.c
  	$(Q)$(call do_fpic_compile)

-$(LIBTRACEEVENT_STATIC): $(OBJS)
+$(LIBTRACEEVENT_STATIC): $(LIBTRACEEVENT_SHARED)
  	$(Q)$(call do_build_static_lib)

  $(LIBTRACEEVENT_SHARED): $(OBJS)
diff --git a/src/event-parse.c b/src/event-parse.c
index 9232f11..8daf91d 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3184,7 +3184,7 @@ process_int_dynamic_array(struct tep_event *event, 
struct tep_print_arg *arg, ch
  	 * The first item within the parenthesis is another field that holds
  	 * the index into where the array starts.
  	 */
-	type = tep_read_token(event->tep, &token);
+	type = read_token(event->tep, &token);
  	if (type != TEP_EVENT_ITEM)
  		return TEP_EVENT_ERROR;

@@ -3213,7 +3213,7 @@ process_int_dynamic_array(struct tep_event *event, 
struct tep_print_arg *arg, ch

  	return read_token_item(event->tep, tok);
  out:
-	tep_free_token(token);
+	free_token(token);
  	*tok = NULL;
  	return TEP_EVENT_ERROR;
  }
@@ -3720,7 +3720,7 @@ process_function(struct tep_event *event, struct 
tep_print_arg *arg,
  		return process_int_array(event, arg, tok);
  	}
  	if (strcmp(token, "__print_dynamic_array") == 0) {
-		tep_free_token(token);
+		free_token(token);
  		return process_int_dynamic_array(event, arg, tok);
  	}
  	if (strcmp(token, "__get_str") == 0 ||

After building libtraceevent and libtracefs, trace-cmd fails to build 
statically:

   BUILD                  trace-cmd
/usr/bin/ld: /ssd/tracecmd-work/trace-cmd/tracecmd/trace-setup-guest.o: 
in function `trace_setup_guest':
trace-setup-guest.c:(.text+0x5c8): warning: Using 'getgrnam' in 
statically linked applications requires at runtime the shared libraries 
from the glibc version used for linking
/usr/bin/ld: /ssd/tracecmd-work/trace-cmd/tracecmd/trace-record.o: in 
function `record_trace.isra.0':
trace-record.c:(.text+0xe705): warning: Using 'initgroups' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: /ssd/tracecmd-work/trace-cmd/tracecmd/trace-record.o: in 
function `do_getaddrinfo':
trace-record.c:(.text+0x865): warning: Using 'getaddrinfo' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: /ssd/tracecmd-work/trace-cmd/tracecmd/trace-record.o: in 
function `record_trace.isra.0':
trace-record.c:(.text+0xe6ee): warning: Using 'getpwnam' in statically 
linked applications requires at runtime the shared libraries from the 
glibc version used for linking
/usr/bin/ld: attempted static link of dynamic object 
`/ssd/tracecmd-work/out/lib64/libtraceevent.a(libtraceevent.so.1.8.4)'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:76: 
/ssd/tracecmd-work/trace-cmd/tracecmd/trace-cmd] Error 1
make: *** [Makefile:405: trace-cmd] Error 2

BTW, this is how I build trace-cmd statically:

TRACECMD_INSTALL_PATH="..."
export LDFLAGS="-static" NO_AUDIT=yes NO_PYTHON=yes CFLAGS="-O3"
make prefix=${TRACECMD_INSTALL_PATH}

Reverting the changes in libtraceevent/src/Makefile resolves this build 
failure, but I guess it's the whole point of this patch?

Thanks,

> ]
> 
>   src/Makefile            |   2 +-
>   src/event-parse-api.c   |   6 +-
>   src/event-parse-local.h |  24 ++--
>   src/event-parse.c       | 298 ++++++++++++++++++++--------------------
>   src/event-plugin.c      |   2 +-
>   src/parse-filter.c      |  22 +--
>   7 files changed, 178 insertions(+), 178 deletions(-)

[snip]
