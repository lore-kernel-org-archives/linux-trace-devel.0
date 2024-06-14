Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAFC1487DC
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jun 2024 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718393663; cv=none; b=ShLXV8gMo2pfcNAmzKKzyJe/ET36/qn2CJupAyJrOnNlckfyMdr7bq+0rMjy5ixxcNBMxQZjEQlDQPV8eEVaxXtlOK8f1g1kHW2p24UaIL0J4SeG0Ht9u31bR4t/ltV6inofXy71Up35OwHBQyBpfMfheGUZEIGILbAUawzDVp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718393663; c=relaxed/simple;
	bh=BLRGd94gSswCQtfhbs9byrexMrza0x0WYIMPJq0LV1g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Ss40SJTm476UFElHsMB+aMeldQKSjVvgfXBbEMiiS8BBE5AuP0c4IbGuhesxKL1KAgHX9FhOY6fXfs1rNAJC/YdZUmIWbYGMU4o0T+MkRy7KvJBirOvefPXwKKaOPOBY6o589OKH2/ZO4LlGL1b4TtQ3s6sSS1dNhhLQLpeT2Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C517BC2BD10;
	Fri, 14 Jun 2024 19:34:22 +0000 (UTC)
Date: Fri, 14 Jun 2024 15:34:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Paul Mars <paul.mars@canonical.com>
Subject: [PATCH] libtraceevent: Have unit test fail when any tests fail
Message-ID: <20240614153421.2c934dc1@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If any of the tests of the unit test fails, make sure it returns non-zero to
allow tools that use this know that a test failed.

Link: https://lore.kernel.org/linux-trace-devel/20240329135331.784707-1-paul.mars@canonical.com/
Reported-by: Paul Mars <paul.mars@canonical.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/trace-utest.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index a26e42e..7c4b9b6 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -37,6 +37,7 @@ int main(int argc, char **argv)
 {
 	CU_BasicRunMode verbose = CU_BRM_VERBOSE;
 	enum unit_tests tests = RUN_NONE;
+	int failed_tests;
 
 	for (;;) {
 		int c;
@@ -82,6 +83,7 @@ int main(int argc, char **argv)
 
 	CU_basic_set_mode(verbose);
 	CU_basic_run_tests();
+	failed_tests = CU_get_number_of_tests_failed();
 	CU_cleanup_registry();
-	return 0;
+	return failed_tests != 0;
 }
-- 
2.43.0

