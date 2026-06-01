Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F03A4F32
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2026 14:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780322623; cv=none; b=RKl7FVRzEb6v/In0fhPcdZXLqtymwnTjQQb6he1dmq0sas0+O0n6QTWwXE7co2KDbjBBH24c++oeDQXZtbghEK0wBVz2fZr02qr+fkRkK4yKIJOXPnqeYMYrXZqXcDShtnCla5DD40k5UUNzDIqozBfBPLC1I1x4K0HoWby8glc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780322623; c=relaxed/simple;
	bh=KxeRywugKGcuIcQqVxfkcXW03prydLRWIYnUa7jns+c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omaDEYyZ8sIaqir6SEKUbc02nafXsLQH/KyGfN7AtST5k9g+54DVYPypF74MQ+acG5ryxr7xcV35yA3WNmZLQuKdg1D6CGL6cRD/8chhsqNv8QDH05Z7LCEWr+iLYtHUr8IP4r2cyDAaHflMot6YTP2Pt5Xfh4Q0uUrP6kStz8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16178162680;
	Mon,  1 Jun 2026 14:03:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id 5924620011;
	Mon,  1 Jun 2026 14:03:33 +0000 (UTC)
Date: Mon, 1 Jun 2026 10:03:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Cao Ruichuang <create0818@163.com>
Cc: linux-trace-devel@vger.kernel.org, Tzvetomir Stoyanov
 <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v3] libtraceevent: avoid racing recursive builds of both
 libraries
Message-ID: <20260601100331.79939cf5@fedora>
In-Reply-To: <20260601082024.12269-1-create0818@163.com>
References: <20260405222102.9204-1-create0818@163.com>
	<20260406062855.58598-1-create0818@163.com>
	<20260529140730.3ea1859b@fedora>
	<20260601082024.12269-1-create0818@163.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5924620011
X-Rspamd-Server: rspamout06
X-Stat-Signature: k5ixa5wq8jqm33auemxy76n7h8t7rc17
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19zWuhasxUSLrRAjZFSpPkQ+nAxM/bomBc=
X-HE-Tag: 1780322613-639353
X-HE-Meta: U2FsdGVkX18HrAb9cr9ybH1iU6EXurHBpaO3NDa862b4ldkVR3lyywCD5bdB7JyAPe3tPkiHvoLdoIiUNZ2JGbaKpr0ZJHQ/Wx13msgwrpJe2aojKex9kg8EqvnueITqfdzUnguymLi3BVCCOxc4skBhSQcqKoKfrESt7iQTt3yDHrUtysHeVucaQRrigcVKMnrrXUznGqZy56yppkEAqyuhOoB+m3kkKCCyIJX8ZCvpyGzzzog0yBcYDl027n8Rneix51Z8ICQEYrUPRLh1Tqk3wvi144r0KzPkzdi+b7nRu+SXyluqoQ9cuH+W+dlyJbGVn+/BqFllj/A0oNlSkageSEOGDBScFO+sCJ6UZD24OttQ7yXaoQ==

On Mon,  1 Jun 2026 16:20:24 +0800
Cao Ruichuang <create0818@163.com> wrote:

> A top-level parallel build currently starts separate recursive makes for
> libtraceevent.a and libtraceevent.so. Both sub-makes rebuild the same
> object files in the same output directory, which can corrupt the .o files
> and make the final link fail with file format errors.
> 
> The src/Makefile already has the static library depend on the shared
> library before running objcopy. Reflect that dependency at the top level
> too by also making the static library target depend on the shared library
> target. This serializes parallel top-level requests for both libraries
> while preserving the shared-before-static build order and the existing
> forced static-library recursive make.
> 
> This fixes the object-file race seen when top-level parallel builds
> request both libraries, for example via `make -j8 libs` or
> `make -j8 libtraceevent.a libtraceevent.so`.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217428
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Cao Ruichuang <create0818@163.com>

Thanks for the updates.

For future version updates, please start a new email thread and do not
reply to the old one. It makes it easier to manage for maintainers.

Also, the tracing code uses capital letters to start subjects:

  [PATCH v3] libtraceevent: Avoid racing recursive builds of both libraries

> ---
> Changes in v3:

In order to still keep the trail of versions, you can use lore with the
Message-ID of the previous email version:

Changes since v2: https://lore.kernel.org/all/20260406062855.58598-1-create0818@163.com/

If all looks good, I'll go ahead and apply your patches.

Thanks again,

-- Steve

> - Follow Steven's review and make the top-level static library target
>   depend on the shared library target, matching src/Makefile's dependency
>   direction.
> - Preserve the existing forced static-library recursive make while
>   serializing parallel top-level requests shared-before-static.
> 
> Tested on x86_64 Linux with GNU Make 4.3, GCC 11.5.0, and GNU objcopy
> 2.35.2:
> - make -j8 libs
> - make -j8 libtraceevent.a libtraceevent.so
> - 20 iterations of: make clean && make -j8 libs
> - 10 iterations of: make clean && make -j8 libtraceevent.a libtraceevent.so
> - make -j8
> - make -j8 test
> 
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index e1a10a0..d1ceaee 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -208,7 +208,7 @@ libtraceevent.so: $(bdir) $(LIBTRACEEVENT_SHARED)
>  
>  libs: libtraceevent.a libtraceevent.so
>  
> -$(LIBTRACEEVENT_STATIC): force
> +$(LIBTRACEEVENT_STATIC): force $(LIBTRACEEVENT_SHARED)
>  	$(Q)$(call descend,$(src)/src,$@)
>  
>  $(LIBTRACEEVENT_SHARED): force

