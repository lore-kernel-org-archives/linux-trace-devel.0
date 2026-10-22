Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792709644;
	b=14SlLt6AHoYeV5hHN9NuP8BdIustfc/5Ukt9CIqEM7RDWey85beahC0d0rxjRGxHr87e
	 0Dcu2RRqQ9xKCzmGN2A97UdNMwuec7UZMWeq5jxlTGAMaoVrtELhyeTMc6LGbrIjZRtk5
	 v5cMx45Ig+sYanC2fXIDXwPN5c8Hi5LDIZq5uXVY8JPniOR6f4i9UgJ+/qzbaSnMMYjl+
	 xVL8ldEuQO75BeJITmbW/RllBLyNcxinvvqPGhhjfPumm34dT1FdRGdVIj+SfA4jyKG3F
	 ZcAHLfjN0WaLtUEeoRHMxM7rU3R36ZFg8YMgjfQ1SfkyQPjl7eqUAYuS7r9k0FOEaGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792709644;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rWnDOrvFM67oW7t1tpHwWv+WgOV46aNJbOg6qwnKcxE=;
	b=WTr+bMpyjisFQliyeUhccn534JO6cZqWJRiAyfmxkQ8s8yrCuhNb88UGTaDBttzSdubi
	 oZcBwzkLCTI9GegM5HsoIc4kgTzgQYzOezzwjjC1vqnV1v22I11ymvEBTrAcplgVjlLIJ
	 zLb2LfAlsLWIIdzVEfw4VCyrWJC0FA0H1JWL4QdzlcOBUPrsGy/tl7N92WyDsqk5JDAXo
	 RTyEU0/iIQs5UrhemS00/w6hE0I4PFf6V8oo7JOfKtQWoiQfoI+0p1tLwAhOs1tsh9heB
	 imrelC/PykKBZDzJO6ew8vE69uW27Sl7k8XNKM5k4mTHdqY2m1eDtek4ZkVRKhlZDEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=fzHgcI4j;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2358606A31B
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Oct 2026 22:54:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2358606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=fzHgcI4j
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6A65B3FE99
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Oct 2026 22:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1792709640;
	bh=rWnDOrvFM67oW7t1tpHwWv+WgOV46aNJbOg6qwnKcxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=fzHgcI4j31/1owuxf2sMzllf7dAeYZ1eRCuvVwYTVfyURJbF0N+o3m/Bdv/fFt8iR
	 PYiURa/4HNzoh4Kb6E08YcIuFFDwI3VJWtBmBm0UZp1eI2wm2NUJ2qcTwUtKh5O8BY
	 7VsRk+dF/ANUecEuhAaOImcD1Caz5J9pflEViJ6/l/sQTYh7Bwzmjr3vDKra0ATTQt
	 Js1686gJ6Bk8PleRL9/tG4pYj+T1p9thBnciEI1aY7R/ZoiTDLqG0R3nJ0aQ16w0/I
	 jV91r1R+0YXSzt5xfdFZdeFSYrJmxgn9dpmyFaAmJM5oDv/2Zo1Jg/2tQFqZJzGfaP
	 uYYoCzNguDAMl5UU8wS3aZebr7BqhNbrJxIQmvelRmXlLvuJFvbHvNJSWnKJrYuf4U
	 Jiul9H7t3N2uQ1yJJNTNrLoLPAQ2YHovcd2DyTgqVTfb+RaYvpCSwwM5ME6Vpm3fvX
	 bjrzB7xacidtomnfzfMRApyqP7BHteyRBfdgNnxXU+m2Sm6NdQaNC0E0c+ZsrehjsP
	 NQ6BC/hWfPZRTDw+3QAdA3ztgA1oz7He4pBqPlSC7iSuq2KRsmOEjEjwiBHVjqfi8m
	 A87yNJ/S+kgNLAId6/chRatmfg7ab5khYfwIXr/dOENtp9BhLbQgvjAyg+KbTgcPuQ
	 /yiQIh8iLumEQqlyQxWw3a00=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a21053899aso1599595e9.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Oct 2026 15:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709640; x=1793314440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rWnDOrvFM67oW7t1tpHwWv+WgOV46aNJbOg6qwnKcxE=;
        b=S7Y3X+MVnWjW+2zSp5rWeDZyP+tp+jmScNmu6J7DfoVvTQCjgyhxcM212s1834ko/J
         ki0ozNdyg630QIr/AkDY2Pg8ulXQoepv3FACCj6vjFi88CkcPGWgMJzElhlOe6+mlShN
         vfEA7Wp0KfJlMEZZWkv6/JewLLCYNVtrdwGemxtnPT/6tEr/RM84AmFQm+wSuoclFfug
         L58Iph4UC/TUC5+z/Sm0aaPZFRGZGL2lG4MAkIujqTTJVM3F3O4jo8ylNI+fkzyLeC2X
         UYSWbqbMiHNRQbm71Q/L0iO2KR/uPjtO+d4Bj+rOgb8AZDHe5Z9Rwdx5Ey8X3lX+d6Yt
         sjZw==
X-Gm-Message-State: AFq9FYL2s1ocW458K+WfLyqELceyohAy78lGYXD10AIwHwqAWh+5uoqE
	WuIPIhscB5U/j+YRxhOGrUd8oVDFI9Vy+d9aOCeN8foxNVN1bcB9jDBasaFbHb8PinohkQMgZbo
	44/VcnXUXCbFuYQDxA3CbmS0YcvN3sLGCuVxW2F1y1woJ35TWk8HKnaat5oI0Y4dwT69rzp9Aqt
	q0niS+s5bTynLs6Y1qlZ6M
X-Gm-Gg: AYBFou3CSQqZ9FYSKfD40MK+hEcMiDTUbpgf/9HGdGu3TKI4LJYWqwkIIBkktHRPFRK
	eYayC7lb8MVQ+hZb7XMRAohezXZOT4w5jW6cTuoy9sdJtX4+D2s/UtYVZ8FPAZdznx06PH3LbmC
	xXZNEtZgiOXgxxt2ogHruP0Krd/2HFB55pKub7NGpdML4q/PMwiGESWZPRWpwpRmpkLUW+jL7B5
	vbu50fXXA0W3aNFlnGUVOtc8cYTZb+yZ+Q7eX8fCyRWNnqI3Us9X5DG3uOml3mu3FriFAESsmjw
	4rnD6F9QfHDMQo35M+T5QW9NC+F0BO40cNoNelTJT/+5p/9D5lNX9r1d+pM2eClYsN4CvsHa1/p
	5Lo9iyhnsbjMLl5GXtI8FNXotfDQeHlQpx3gvVVu24bwhKi4S8IttdwuvgZ1fxhySuKhzCerj8Y
	UXqvo=
X-Received: by 2002:a05:600c:8b41:b0:4a1:e9c2:6c84 with SMTP id 5b1f17b1804b1-4a211efe1f2mr5856745e9.18.1792709639831;
        Thu, 22 Oct 2026 15:53:59 -0700 (PDT)
X-Received: by 2002:a05:600c:8b41:b0:4a1:e9c2:6c84 with SMTP id 5b1f17b1804b1-4a211efe1f2mr5856605e9.18.1792709639397;
        Thu, 22 Oct 2026 15:53:59 -0700 (PDT)
Received: from curves.ddrung.de (2a00-12d0-b0ea-16f0-e90a-519c-7703-6c41.ip.tng.de. [2a00:12d0:b0ea:16f0:e90a:519c:7703:6c41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e38063d63sm813449f8f.56.2026.10.22.15.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:53:57 -0700 (PDT)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH 2/2] libtracefs Documentation: fix various spelling mistakes
Date: Fri, 23 Oct 2026 00:53:12 +0200
Message-ID: <20261022225313.1953932-2-benjamin.drung@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261022225313.1953932-1-benjamin.drung@canonical.com>
References: <20261022225313.1953932-1-benjamin.drung@canonical.com>
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lintian found following spelling mistakes:

```
I: libtracefs-doc: typo-in-manual-page "allows to" "allows one to" [usr/share/man/man3/tracefs_hist_add_sort_key.3.gz:76]
I: libtracefs-doc: typo-in-manual-page "allows to" "allows one to" [usr/share/man/man3/tracefs_hist_alloc.3.gz:91]
I: libtracefs-doc: typo-in-manual-page "allows to" "allows one to" [usr/share/man/man3/tracefs_options_get_supported.3.gz:58]
I: libtracefs-doc: typo-in-manual-page attemp attempt [usr/share/man/man3/tracefs_function_filter.3.gz:60]
I: libtracefs-doc: typo-in-manual-page destory destroy [usr/share/man/man3/tracefs_kprobe_alloc.3.gz:67]
I: libtracefs-doc: typo-in-manual-page exluding excluding [usr/share/man/man3/tracefs_dynevent_create.3.gz:65]
I: libtracefs-doc: typo-in-manual-page formated formatted [usr/share/man/man3/tracefs_print_init.3.gz:31]
I: libtracefs-doc: typo-in-manual-page formated formatted [usr/share/man/man3/tracefs_print_init.3.gz:44]
I: libtracefs-doc: typo-in-manual-page gloabl global [usr/share/man/man3/tracefs_file_exists.3.gz:94]
I: libtracefs-doc: typo-in-manual-page gloabl global [usr/share/man/man3/tracefs_instance_file_open.3.gz:113]
I: libtracefs-doc: typo-in-manual-page hexidecimal hexadecimal [usr/share/man/man3/tracefs_instance_set_affinity.3.gz:57]
I: libtracefs-doc: typo-in-manual-page intead instead [usr/share/man/man3/tracefs_iterate_raw_events.3.gz:74]
I: libtracefs-doc: typo-in-manual-page specifing specifying [usr/share/man/man3/tracefs_hist_alloc.3.gz:91]
I: libtracefs-doc: typo-in-manual-page subsitute substitute [usr/share/man/man1/sqlhist.1.gz:375]
I: libtracefs-doc: typo-in-manual-page succesfully successfully [usr/share/man/man3/tracefs_get_tracing_file.3.gz:58]
I: libtracefs-doc: typo-in-manual-page sytem system [usr/share/man/man3/tracefs_event_get_file.3.gz:99]
I: libtracefs-doc: typo-in-manual-page transfered transferred [usr/share/man/man3/tracefs_trace_pipe_stream.3.gz:52]
```

Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
---
 Documentation/libtracefs-dynevents.txt            | 2 +-
 Documentation/libtracefs-events-file.txt          | 2 +-
 Documentation/libtracefs-files.txt                | 2 +-
 Documentation/libtracefs-function-filter.txt      | 2 +-
 Documentation/libtracefs-hist-mod.txt             | 2 +-
 Documentation/libtracefs-hist.txt                 | 4 ++--
 Documentation/libtracefs-instances-affinity.txt   | 2 +-
 Documentation/libtracefs-instances-file-manip.txt | 2 +-
 Documentation/libtracefs-instances-files.txt      | 2 +-
 Documentation/libtracefs-iterator.txt             | 2 +-
 Documentation/libtracefs-kprobes.txt              | 2 +-
 Documentation/libtracefs-marker.txt               | 4 ++--
 Documentation/libtracefs-option-get.txt           | 2 +-
 Documentation/libtracefs-sqlhist.txt.1            | 2 +-
 Documentation/libtracefs-stream.txt               | 2 +-
 15 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
index bd5fbfd..60cbea2 100644
--- a/Documentation/libtracefs-dynevents.txt
+++ b/Documentation/libtracefs-dynevents.txt
@@ -63,7 +63,7 @@ The *tracefs_dynevent_info*() function returns the type and information of a giv
 _dynevent_. If any of the _system_, _event_, _prefix_, _addr_ or _format_ arguments are not NULL,
 then strings are allocated and returned back via these arguments. The _system_ and _event_ holds the
 system and the name of the dynamic event. If _prefix_ is non NULL, then it will hold an allocated
-string that holds the prefix portion of the dynamic event (the content up to the ":", exluding it).
+string that holds the prefix portion of the dynamic event (the content up to the ":", excluding it).
 If _addr_ is non NULL, it will hold the address or function that the dynamic event is attached to,
 if relevant for this event type. If _format_ is non NULL, it will hold the format string of the
 dynamic event. Note, that the content in _group_, _event_, _prefix_, _addr_, and _format_ must be
diff --git a/Documentation/libtracefs-events-file.txt b/Documentation/libtracefs-events-file.txt
index 4a56cf3..9458f73 100644
--- a/Documentation/libtracefs-events-file.txt
+++ b/Documentation/libtracefs-events-file.txt
@@ -108,7 +108,7 @@ int main(int argc, char **argv)
 	int size;
 
 	if (argc < 4) {
-		printf("usage: %s sytem event file [(-a|-w) write | -c]\n"
+		printf("usage: %s system event file [(-a|-w) write | -c]\n"
 		       "   reads the system/event file or writes if [write is supplied]\n",
 		       argv[0]);
 		exit(0);
diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index f77af46..f6408e4 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -55,7 +55,7 @@ be freed.
 
 *tracefs_tracing_dir_is_mounted()* returns 1 if the tracing directory is
 already mounted and 0 if it is not. If _mount_ is true, it will try to
-mount it if it is not, and returns 0 if it succesfully mounted it and -1
+mount it if it is not, and returns 0 if it successfully mounted it and -1
 if it did not. If _path_ is set, it will be assigned to the path where it
 mounted it. _path_ is internal and should not be freed.
 
diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 88d5d06..125790e 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -83,7 +83,7 @@ first filter to be added before committing.
 
 *TRACEFS_FL_FUTURE* :
 If _flags_ contains *TRACEFS_FL_FUTURE* and _module_ holds a string of a module,
-then if the module is not loaded it will attemp to write the filter with the module
+then if the module is not loaded it will attempt to write the filter with the module
 in the filter file. Starting in Linux v4.13 module functions could be added to the
 filter before they are loaded. The filter will be cached, and when the module is
 loaded, the filter will be set before the module executes, allowing to trace
diff --git a/Documentation/libtracefs-hist-mod.txt b/Documentation/libtracefs-hist-mod.txt
index e51c823..155813b 100644
--- a/Documentation/libtracefs-hist-mod.txt
+++ b/Documentation/libtracefs-hist-mod.txt
@@ -67,7 +67,7 @@ and so on, but all sort keys must match an existing key or value, or be
 TRACEFS_HIST_HITCOUNT. The last parameter of *tracefs_hist_add_sort_key*() must
 be NULL.
 
-*tracefs_hist_sort_key_direction*() allows to change the direction of an
+*tracefs_hist_sort_key_direction*() allows changing the direction of an
 existing sort key of _hist_. The _sort_key_ is the sort key to change, and
 _dir_ can be either TRACEFS_HIST_SORT_ASCENDING or TRACEFS_HIST_SORT_DESCENDING,
 to make the direction of the sort key either ascending or descending respectively.
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index dba88ea..98d6f26 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -102,10 +102,10 @@ histogram descriptor to add the _key_ to. The _type_ is the type of key to add
 (See KEY TYPES below).
 
 The *tracefs_hist_add_key_cnt*() is the same as *tracefs_hist_add_key*() except
-that it allows to add a counter for the given type. Currently, there's only
+that it allows adding a counter for the given type. Currently, there's only
 the *buckets* type that requires a counter. When adding a key with the buckets
 type, *tracefs_hist_add_key*() is not sufficient, as the *buckets* type requires
-a counter or bucket size. Use *tracefs_hist_add_key_cnt*() when specifing
+a counter or bucket size. Use *tracefs_hist_add_key_cnt*() when specifying
 a key that is broken up into  buckets, and pass in the size of those buckets
 into _cnt_.
 
diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index 2283ae5..2e04f32 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -44,7 +44,7 @@ _set_. If _set_ is NULL then all the CPUs on the system will be set, and _set_si
 is ignored.
 
 The *tracefs_instance_set_affinity_raw()* function takes a string that holds
-a hexidecimal bitmask, where each 32 bits is separated by a comma. For a
+a hexadecimal bitmask, where each 32 bits is separated by a comma. For a
 machine with more that 32 CPUs, to set CPUS 1-10 and CPU 40:
 
  "100,000007fe"
diff --git a/Documentation/libtracefs-instances-file-manip.txt b/Documentation/libtracefs-instances-file-manip.txt
index 5dca8f3..efece12 100644
--- a/Documentation/libtracefs-instances-file-manip.txt
+++ b/Documentation/libtracefs-instances-file-manip.txt
@@ -114,7 +114,7 @@ struct tracefs_instance *inst = tracefs_instance_create("foo");
 		free(clock);
 
 		if (tracefs_instance_file_write(inst, "trace_clock", "global") != strlen("global")) {
-			/* Failed to set gloabl trace clock in instance foo */
+			/* Failed to set global trace clock in instance foo */
 			...
 		}
 	} else {
diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index 0f91f01..852ffb2 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -81,7 +81,7 @@ struct tracefs_instance *inst = tracefs_instance_create("foo");
 		free(clock);
 
 		if (tracefs_instance_file_write(inst, "trace_clock", "global") != strlen("global")) {
-			/* Failed to set gloabl trace clock in instance foo */
+			/* Failed to set global trace clock in instance foo */
 			...
 		}
 	} else {
diff --git a/Documentation/libtracefs-iterator.txt b/Documentation/libtracefs-iterator.txt
index d2e24dd..48984a7 100644
--- a/Documentation/libtracefs-iterator.txt
+++ b/Documentation/libtracefs-iterator.txt
@@ -68,7 +68,7 @@ the iterator (even though a return of non-zero will stop it), or from another
 thread.
 
 The *tracefs_follow_event()* is used with *tracefs_iterate_raw_events()* but
-intead of the callback being called for every event, it is only called for the
+instead of the callback being called for every event, it is only called for the
 specified _system_ / _event_name_ given to the function. The _callback_ is the
 same as for *tracefs_iterate_raw_events()*, and the passed in _callback_context_
 will be passed to the _callback_ as well. Note, if it returns something other
diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index dc4c611..4288955 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -70,7 +70,7 @@ tracefs_dynevent structure, describing the probe. This pointer must be freed by
 not modify the running system.
 
 The *tracefs_kprobe_destroy*() returns 0 on success or -1 on error if it was not able to
-successful destory (or find) the kprobe or kretprobe.
+successful destroy (or find) the kprobe or kretprobe.
 
 
 ERRORS
diff --git a/Documentation/libtracefs-marker.txt b/Documentation/libtracefs-marker.txt
index 201312a..b5dfc8e 100644
--- a/Documentation/libtracefs-marker.txt
+++ b/Documentation/libtracefs-marker.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_print_init, tracefs_print_close, tracefs_printf, tracefs_vprintf -
-Open, close and write formated strings in the trace buffer.
+Open, close and write formatted strings in the trace buffer.
 
 SYNOPSIS
 --------
@@ -21,7 +21,7 @@ void *tracefs_print_close*(struct tracefs_instance pass:[*]_instance_);
 
 DESCRIPTION
 -----------
-Set of functions to write formated strings in the trace buffer.
+Set of functions to write formatted strings in the trace buffer.
 See Documentation/trace/ftrace.rst from the Linux kernel tree for more information about writing
 data from user space in the trace buffer. All these APIs have _instance_ as a first argument. If
 NULL is passed as _instance_, the top trace instance is used.
diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index ca48b20..cac914f 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -45,7 +45,7 @@ The *tracefs_option_mask_is_set()* function checks if the bit, corresponding to
 set in the _options_ bitmask returned from *tracefs_option_get_enabled()* and *tracefs_option_is_supported()*.
 
 The *tracefs_option_id()* converts an option _name_ into its corresponding id, if it is found.
-This allows to find the option _id_ to use in the other functions if only the _name_ is known.
+This allows finding the option _id_ to use in the other functions if only the _name_ is known.
 
 RETURN VALUE
 ------------
diff --git a/Documentation/libtracefs-sqlhist.txt.1 b/Documentation/libtracefs-sqlhist.txt.1
index 75e93e1..fcfac03 100644
--- a/Documentation/libtracefs-sqlhist.txt.1
+++ b/Documentation/libtracefs-sqlhist.txt.1
@@ -252,7 +252,7 @@ Now a breakdown of the SQL statement:
    Create the synthetic event by joining _sched_waking_ to _sched_switch_, matching
    the _sched_waking_ 'pid' field with the _sched_switch_ 'next_pid' field.
    Also make *start* an alias for _sched_waking_ and *end* an alias for _sched_switch_
-   which then an use *start* and *end* as a subsitute for _sched_waking_ and _sched_switch_
+   which then an use *start* and *end* as a substitute for _sched_waking_ and _sched_switch_
    respectively through out the rest of the SQL statement.
 
  *WHERE end.next_prio < 100 && end.next_comm == "cyclictest"*::
diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
index e88c0b0..c299c76 100644
--- a/Documentation/libtracefs-stream.txt
+++ b/Documentation/libtracefs-stream.txt
@@ -42,7 +42,7 @@ the stream of trace data is redirected to stdout.
 RETURN VALUE
 ------------
 The *tracefs_trace_pipe_stream()*, and *tracefs_trace_pipe_print()* functions return the
-number of bytes transfered if the operation is successful, or -1 in case of an error.
+number of bytes transferred if the operation is successful, or -1 in case of an error.
 
 EXAMPLE
 -------
-- 
2.53.0

