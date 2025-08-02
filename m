Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2638F58
	for <linux-trace-devel@vger.kernel.org>; Sat,  2 Aug 2025 01:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754099276; cv=none; b=BD4vyBmqlaqNyIwYpvyB4GGgURaoilUuMI7NukNYbgJMpN8DU3n0LvLDjaVBQRjBJ2iOIIwMSf6pBNEALXF022sFpEU0CBziZ6M0oxSdKmW8di1tmDZXOJUBNcOrm8CXvSMMyy4XTl+GlcG8Kk+AkuHLLAx86hBOz0+E2GsFAw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754099276; c=relaxed/simple;
	bh=URTVRsPH9iTzfN6iNkFNAFgXV9fFIxGNHTGd1jcboBg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l9ET1SuxQ8nr52Qjo2c9UOAX4J5Flwn5P02WQLnhRurkX9ZVrvjr9z1Eb41igOGftzwHSQL5U0A1IGtIlSVa8a7VN+YJRZvNphFYoSpQzUy5p15+eh/ojNu6IpygQnhPGmWYfNmaok4odJyUHATojUDYL/juCPTyeKR7evYkX/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C2D4134C70;
	Sat,  2 Aug 2025 01:47:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 993BE20028;
	Sat,  2 Aug 2025 01:47:45 +0000 (UTC)
Date: Fri, 1 Aug 2025 21:47:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Sojka <michal.sojka@cvut.cz>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] libtracefs: utest: Return non-zero exit code
 when something fails
Message-ID: <20250801214747.21876847@batman.local.home>
In-Reply-To: <20250728143433.1114222-1-michal.sojka@cvut.cz>
References: <20250720221617.695311-1-michal.sojka@cvut.cz>
	<20250728143433.1114222-1-michal.sojka@cvut.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 993BE20028
X-Stat-Signature: omun5rst7rxa8dntcm4ogkok7ffrajyj
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18HDyKjWTxhEB+9KJEfnHhZgFdNffEV5+A=
X-HE-Tag: 1754099265-760859
X-HE-Meta: U2FsdGVkX186iOkmezFjTl9fJyXe8aGR2mzu5V1bNd3jQS9dUY0UsQkA/x+D6a9wzSE6S0aELQ+5QVCEBgpS2YQTiNzb6jdErmVEjfvDSxVifba06mu4ZJxk0NYZbFVUqYpbbw+VLsyzsDVUUGP9/zpVaBIGXOyi5V5Y6+gQp19DzCV5pJ+//Hpr61Q89GXLuHRo7b7ytoo2rfF2khk30u7oZjc/WB4HX6KgMViJjSwp5//Pz9kKx6GgtYJKV1RDztESuNBvaRu8GA2956I4h5HHFccwzc91a7BG8g8zKSGp1vWguiqaPCFxFuI4qUG8


This is a "v2" of just 1/2. I don't see a 2/2 of this version.

-- Steve



On Mon, 28 Jul 2025 16:34:33 +0200
Michal Sojka <michal.sojka@cvut.cz> wrote:

> Previously, the test suite returned zero exit status even if something
> failed. One could learn about the failure from the output, such as:
> 
>     WARNING - Suite initialization failed for 'tracefs library'.
>     Run Summary:    Type  Total    Ran Passed Failed Inactive
>                   suites      1      0    n/a      1        0
>                    tests     37      0      0      0        0
> 
> However, when the test suite is run via meson, i.e. with:
> 
>     meson setup build && meson test -C build
> 
> Meson always reports success, because it primarily looks at process
> exit code.
> 
> To not make meson mask failures, this commit sets the exit code to one
> if some suite (we have just one) or test fails. Additionally, it
> prints error messages in the suite initialization function, to make
> the failure more understandable.
> 
> Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
> 
> ---
> Changes in v2:
> - Fixed typos in the commit message.
> - Use tabs instead of spaces for indentation.
> ---
>  utest/trace-utest.c   | 8 +++++++-
>  utest/tracefs-utest.c | 8 ++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/utest/trace-utest.c b/utest/trace-utest.c
> index 39485a1..b40a217 100644
> --- a/utest/trace-utest.c
> +++ b/utest/trace-utest.c
> @@ -79,6 +79,12 @@ int main(int argc, char **argv)
>  
>  	CU_basic_set_mode(verbose);
>  	CU_basic_run_tests();
> +
> +	int err = CU_get_error() != CUE_SUCCESS ||
> +		CU_get_number_of_suites_failed() > 0 ||
> +		CU_get_number_of_failures() > 0;
> +
>  	CU_cleanup_registry();
> -	return 0;
> +
> +	return err ? 1 : 0;
>  }
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index cc7e689..4a412b2 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -3849,11 +3849,15 @@ static int test_suite_destroy(void)
>  static int test_suite_init(void)
>  {
>  	test_tep = tracefs_local_events(NULL);
> -	if (test_tep == NULL)
> +	if (test_tep == NULL) {
> +		perror("tracefs_local_events");
>  		return 1;
> +	}
>  	test_instance = tracefs_instance_create(TEST_INSTANCE_NAME);
> -	if (!test_instance)
> +	if (!test_instance) {
> +		perror("tracefs_instance_create");
>  		return 1;
> +	}
>  
>  	mapping_is_supported = tracefs_mapped_is_supported();
>  	if (mapping_is_supported)

