Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9130B30FA0
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 20:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E55C433C8;
	Fri,  6 Oct 2023 20:11:04 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qorBH-005oRi-2V;
	Fri, 06 Oct 2023 16:12:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/3] libtraceeval: Add man pages for insert/remove/query of traceeval_delta items
Date: Fri,  6 Oct 2023 16:12:13 -0400
Message-Id: <20231006201214.1385447-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006201214.1385447-1-rostedt@goodmis.org>
References: <20231006201214.1385447-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add man pages for:

 traceeval_delta_insert()
 traceeval_delta_insert_size()
 traceeval_delta_remove()
 traceeval_delta_remove_size()
 traceeval_delta_query()
 traceeval_delta_query_size()
 traceeval_delta_results_release()

Link: https://lore.kernel.org/linux-trace-devel/20231006185405.1379249-3-rostedt@goodmis.org

Cc: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceeval-delta-insert.txt | 122 ++++++++++++++++++++
 Documentation/libtraceeval.txt              |  22 ++++
 2 files changed, 144 insertions(+)
 create mode 100644 Documentation/libtraceeval-delta-insert.txt

diff --git a/Documentation/libtraceeval-delta-insert.txt b/Documentation/libtraceeval-delta-insert.txt
new file mode 100644
index 000000000000..23ef6b201fe9
--- /dev/null
+++ b/Documentation/libtraceeval-delta-insert.txt
@@ -0,0 +1,122 @@
+libtraceeval(3)
+===============
+
+NAME
+----
+traceeval_delta_insert, traceeval_delta_insert_size, traceeval_delta_remove,
+traceeval_delta_remove_size, traceeval_delta_query, traceeval_delta_query_size,
+traceeval_delta_results_release - Insert, remove, query traceeval delta elements
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <traceeval.h>*
+
+
+int *traceeval_delta_insert*(struct traceeval_delta pass:[*]_tdelta_,
+			   const struct traceeval_data pass:[*]_keys_,
+			   const struct traceeval_data pass:[*]_vals_);
+int *traceeval_delta_insert_size*(struct traceeval_delta pass:[*]_tdelta_,
+				const struct traceeval_data pass:[*]_keys_, size_t _nr_keys_,
+				const struct traceeval_data pass:[*]_vals_, size_t _nr_vals_);
+
+int *traceeval_delta_remove*(struct traceeval_delta pass:[*]_tdelta_,
+			   const struct traceeval_data pass:[*]_keys_);
+int *traceeval_delta_remove_size*(struct traceeval_delta pass:[*]_tdelta_,
+				const struct traceeval_data pass:[*]_keys_, size_t _nr_keys_);
+
+int *traceeval_delta_query*(struct traceeval_delta pass:[*]_tdelta_, const struct traceeval_data pass:[*]_keys_,
+			  const struct traceeval_data pass:[**]_results_);
+int *traceeval_delta_query_size*(struct traceeval_delta pass:[*]_tdelta_,
+			       const struct traceeval_data pass:[*]_keys_,
+			       size_t nr_keys, const struct traceeval_data pass:[**]_results_);
+
+void *traceeval_delta_results_release*(struct traceeval_delta pass:[*]_tdelta_,
+				     const struct traceeval_data pass:[*]_results_);
+--
+
+DESCRIPTION
+-----------
+These functions manipulate the traceeval_delta created by *traceeval_delta_init*(3),
+and act very similar to the functions with the similar names for the traceeval
+element (see *traceeval_insert*(3)).
+
+
+The *traceveal_delta_insert()* will create a new instance if one does not exist
+that matches the _keys_, or it will update an existing one. Note, this will not
+modify the timestamp or delta associated with the instance. For new instances
+the timestamp and delta will be zero, and for existing ones, they will remain
+unchanged.
+
+Note that the _keys_ and _vals_ for *traceeval_data_insert()* must be static arrays.
+If dynamic arrays are required, then use *traceeval_data_insert_size()* that
+takes two additional arguments: _nr_keys_ to denote how many _keys_ are there,
+and _nr_vals_ for the number of _vals_.
+
+Use *traceeval_delta_remove()* or *traceeval_delta_remove_size()* to remove
+an instance matching the _keys_ from the traceeval_delta. The difference between
+the two functions is that *traceeval_delta_remove()* requires _keys_ to be a
+static array.
+
+The *traceeval_delta_query()* will return the element that matches the _keys_. The
+_keys_ must be a static array that is the same size as the key types defined by
+*traceeval_init()*. If an element is found, it will fill in the _results_
+pointer to point to the content of the values for the given element. The
+results must be released with *traceeval_delta_results_release()*.
+
+The *traceeval_delta_results_release()* will release any necessary resources that a
+*traceeval_delta_query()* may have added to return the _results_.
+
+RETURN VALUE
+------------
+The *traceeval_delta_insert()* and *traceeval_delta_insert_size()* return 0 on succes and -1 on error.
+
+The *traceeval_delta_remove()* and *traceeval_delta_remove_size()* returns 1 if the item was found and removed,
+0 if the item was not found, and -1 on an error (like invalid keys).
+
+The *traceeval_delta_query()* and *traceveal_delta_query_size()* return 1 if the item is found that matches
+the _keys_ and _results_ will contain the values of the last values of that time. It will return
+0 if not found, and -1 on error (like invalid keys).
+
+
+EXAMPLE
+-------
+The usage for these functions are the same as the functions with similar names with
+traceeval, and referencing those functions will give the same use cases.
+
+FILES
+-----
+[verse]
+--
+*traceval.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceeval*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtraceeval*(3),
+*traceeval_insert*(3),
+*traceeval_insert_size*(3),
+*traceeval_remove*(3),
+*traceeval_remove_size*(3),
+*traceeval_query*(3),
+*traceeval_query_size*(3),
+*traceeval_results_release*(3)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceeval*.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceeval is licensed under MIT.
+
diff --git a/Documentation/libtraceeval.txt b/Documentation/libtraceeval.txt
index 4d23ba0c5928..68fc182f7c46 100644
--- a/Documentation/libtraceeval.txt
+++ b/Documentation/libtraceeval.txt
@@ -103,6 +103,28 @@ Handling delta times between events:
 	int *traceeval_delta_continue_size*(struct traceeval_delta pass:[*]_tdelta_,
 				  const struct traceeval_data pass:[*]keys, size_t _nr_keys_,
 				  unsigned long long _timestamp_);
+
+Handling insertion, deletion and querying of traceeval_delta elements:
+	int *traceeval_delta_insert*(struct traceeval_delta pass:[*]_tdelta_,
+			   const struct traceeval_data pass:[*]_keys_,
+			   const struct traceeval_data pass:[*]_vals_);
+	int *traceeval_delta_insert_size*(struct traceeval_delta pass:[*]_tdelta_,
+				const struct traceeval_data pass:[*]_keys_, size_t _nr_keys_,
+				const struct traceeval_data pass:[*]_vals_, size_t _nr_vals_);
+
+	int *traceeval_delta_remove*(struct traceeval_delta pass:[*]_tdelta_,
+			   const struct traceeval_data pass:[*]_keys_);
+	int *traceeval_delta_remove_size*(struct traceeval_delta pass:[*]_tdelta_,
+				const struct traceeval_data pass:[*]_keys_, size_t _nr_keys_);
+
+	int *traceeval_delta_query*(struct traceeval_delta pass:[*]_tdelta_, const struct traceeval_data pass:[*]_keys_,
+			  const struct traceeval_data pass:[**]_results_);
+	int *traceeval_delta_query_size*(struct traceeval_delta pass:[*]_tdelta_,
+			       const struct traceeval_data pass:[*]_keys_,
+			       size_t nr_keys, const struct traceeval_data pass:[**]_results_);
+
+	void *traceeval_delta_results_release*(struct traceeval_delta pass:[*]_tdelta_,
+				     const struct traceeval_data pass:[*]_results_);
 --
 
 DESCRIPTION
-- 
2.40.1

